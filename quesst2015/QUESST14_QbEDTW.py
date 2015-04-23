#!/usr/bin/env python
"""Script for QUESST14 Query-by-Example Dynamic Time Warping.
Usage: QUESST14_QbEDTW.py <options> query_dir audio_dir query_list audio_list out_dir

File:      QUESST14_QbEDTW.py
Date:      10-06-2014 (last updated 26-03-2015)
Author(s): Igor Szoke, Miroslav Skacel, Lukas Burget
           BUT Speech@FIT, Brno University of Technology, Czech Republic

In case you use this script to generate results for your paper, please,
refer to this article:
  @inproceedings{
     author = {Igor Sz{\H{o}}ke and Luk{\'{a}}{\v{s}} Burget and
          Franti{\v{s}}ek Gr{\'{e}}zl and Jan {\v{C}}ernock{\'{y}} and
          Lucas Ondel},
     title = {Calibration and Fusion of Query-by-example Systems - BUT SWS
          2013},
     pages = {7899--7903},
     booktitle = {Proceedings of ICASSP 2014},
     year = {2014},
     location = {Florencie, IT},
     publisher = {IEEE Signal Processing Society},
     ISBN = {978-1-4799-2892-7},
     language = {english},
     url = {http://www.fit.vutbr.cz/research/view_pub.php?id=10557}
  }
"""
import sys
import time
import logging
import numpy as np
from optparse import OptionParser
from itertools import compress
import scipy.spatial as spatial


def readhtk(file):
    """Reads htk data file using htk.py module."""
    import htkmfc
    return htkmfc.HTKFeat_read(file).getall()


def fdtwsrmq2(test, queries, metric='cos'):
    """Calculates distance, cumulate, length and starting-point matrices.
    Input:
      test    - array with reference files
      queries - array with query files
      metric  - distance metric used for vector comparison
                (logdot, logcos, dot, euc, corr, cos)
    Output:
      scores       - scores from matrix with accumulated distances
      start-points - starting-point values
    """
    # init matrix
    qlens = [len(q) for q in queries]
    C = np.empty((len(test)+1, max(qlens)+1, len(queries)), dtype=np.float32)
    C[:] = np.inf
    C[1:,0] = 0.0

    logging.info("Using " + metric + " distance.")
    # calculate distance
    if metric == 'logdot':
        test = ne.evaluate("exp(test)")
        for ii, q in enumerate(queries):
            qt = q.T
            qt = ne.evaluate("exp(qt)")
            C[1:, 1:len(q)+1, ii] = -np.log(test.dot(qt))
    elif metric == 'logcos':
        test = ne.evaluate("exp(test)")
        testnorm = 1.0/np.sqrt(ne.evaluate("sum(test**2,axis=1)"))
        for ii, q in enumerate(queries):
            qt = q.T
            qt = ne.evaluate("exp(qt)")
            qtnorm = 1.0/np.sqrt(ne.evaluate("sum(qt**2,axis=0)"))
            C[1:, 1:len(q)+1, ii] = -np.log(test.dot(qt)*qtnorm*testnorm[:,np.newaxis])
    elif metric == 'dot':
        for ii, q in enumerate(queries):
            qt = q.T
            C[1:, 1:len(q)+1, ii] = test.dot(qt)
    elif metric == 'euc':
        for ii, q in enumerate(queries):
            C[1:, 1:len(q)+1, ii] = spatial.distance.cdist(test, q, 'euclidean')
    elif metric == 'corr':
        for ii, q in enumerate(queries):
            C[1:, 1:len(q)+1, ii] = spatial.distance.cdist(test, q, 'correlation')
    elif metric == 'cos':
        for ii, q in enumerate(queries):
            C[1:, 1:len(q)+1, ii] = spatial.distance.cdist(test, q, 'cosine')
    else:
        logging.error("Unknown distance metric!")
        sys.exit(-1)

    # calculate other matrices
    L = np.zeros_like(C, dtype=np.uint16)
    S = np.zeros_like(C, dtype=np.uint16)
    S[:, 0] = np.arange(len(S))[:, np.newaxis]-1
    qrange = np.arange(len(queries))
    for j in range(1, C.shape[0]):
        for i in range(1, C.shape[1]):
            predecesors = np.array([[j-1, j-1, j], [i-1, i, i-1]])
            bestpred = tuple(predecesors[:,np.argmin((C[tuple(predecesors)]+C[j,i])/
                             (L[tuple(predecesors)]+1),axis=0)]) + (qrange,)
            C[j,i] += C[bestpred]
            L[j,i] = L[bestpred] + 1
            S[j,i] = S[bestpred]
    C[1:,1:] /= L[1:,1:]
    return np.vstack([C[1:, qlens[ii]-1, ii] for ii in qrange]), np.vstack([S[1:, qlens[ii]-1, ii] for ii in qrange])


def main():
    usage = "%prog query_dir audio_dir query_list audio_list out_dir"
    desc = """Script for QUESST14 Query-by-Example Dynamic Time Warping."""
    version = "%prog 0.0"
    # options
    parser = OptionParser(usage=usage, description=desc, version=version)
    parser.add_option("-v", "--vad", action="store", type=str,
        help="Load text file with lines: query_name start_frame stop_frame",
        default=None)
    parser.add_option("-D", "--dist", action="store", type=str,
        help="Distance metric",
        default=None)
    parser.add_option("-f", "--feats", action="store", type=str,
        help="Features extension",
        default='fea')
    parser.add_option("-L", "--logging", action="store", type=str, 
        help="Level of logging information",
        default='NOTSET')
    (opt, args) = parser.parse_args()

    # set logging format
    num_val = getattr(logging, opt.logging.upper(), None)
    logging.basicConfig(format="[%(levelname)s]\t%(message)s", level=num_val)

    if(len(args) != 5):
        parser.print_help()
        logging.error("Incorrect number of arguments!")
        sys.exit(-1)

    query_dir, audio_dir, query_list, audio_list, out_dir = args

    # print logging
    t = time.time()
    logging.info('-'*80)
    logging.info("vad_file = " + str(opt.vad))
    logging.info("query_dir = " + query_dir)
    logging.info("query_list = " + query_list)
    logging.info("audio_dir = " + audio_dir)
    logging.info("audio_list = " + audio_list)
    logging.info("out_dir = " + out_dir)
    logging.info("dist = " + opt.dist)
    logging.info("feats = " + opt.feats)
    logging.info('-'*80)

    # load VAD file
    if opt.vad is not None:
        vad_dict = {n: s for n,s in np.loadtxt(opt.vad, dtype=object)}

    # load lists
    query_list = np.loadtxt(query_list, dtype=object)
    audio_list = np.loadtxt(audio_list, dtype=object, ndmin=1)

    # load queries
    queries = []
    for i, f in enumerate(query_list):
        if opt.vad is not None:
            vad_dict[f] = [int(x) for x in vad_dict[f]]
        q = readhtk(query_dir+'/'+f+'.'+opt.feats)
        if opt.vad is not None:
            q = np.array(list(compress(q,vad_dict[f])))
        queries.append(q)
        logging.info("query "+f+ "; shape: "+str(queries[-1].shape)+"; vad: "+('None' if opt.vad is None else str(vad_dict[f].count(1))))
        print i+1,'/',len(query_list), f


    # load references and performs DTW
    for i, fn in enumerate(audio_list):
        test = []
        logging.info('-'*80)
        test = readhtk(audio_dir+'/'+fn+'.'+opt.feats)
        logging.info("test "+fn+ "; shape: "+str(test.shape))
        print i+1,'/',len(audio_list), fn

        score_mx, start_mx = fdtwsrmq2(test, queries, opt.dist)

        logging.info("Searching paths for "+fn)
        dets = []
        for kwd_ind, kwd_name in enumerate(query_list):
            local_mins=np.nonzero(np.diff(np.sign(np.diff(np.r_[np.inf, score_mx[kwd_ind], np.inf]))) == 2)[0]
            starts_at_mins = start_mx[kwd_ind][local_mins]
            for s in np.unique(starts_at_mins):
                local_mins_starting_at_s = local_mins[starts_at_mins == s]
                e = local_mins_starting_at_s[np.argmin(score_mx[kwd_ind][local_mins_starting_at_s])]
                dets.append((s * 100000, e * 100000, kwd_name, -score_mx[kwd_ind][e]))
        logging.info("Saving results to "+out_dir+'/'+fn+'.lab')
        np.savetxt(out_dir+'/'+fn+'.lab', np.array(dets, dtype=object), fmt='%d %d %s %f')
        logging.info("Done.")
        logging.info("Runtime: " + str(time.time()-t) + " seconds.")


if(__name__ == "__main__"):
    main()
