#
# Example Makefile for QUESST2015 VM
#
#   Some of the targets use the SLURM scheduler (check that they are all done)
#   Some directly compute the results (when the prerequisites are hopefully ok)
#

# ---- [1] Feature Extraction ----
#
# find QUESST2015-dev/dev_queries  -name '*.wav'|sed 's/^/Example\//'|sed 's/.wav/.hungarian.htk/'|xargs -n 1 make
# find QUESST2015-dev/eval_queries -name '*.wav'|sed 's/^/Example\//'|sed 's/.wav/.hungarian.htk/'|xargs -n 1 make
# find QUESST2015-dev/Audio        -name '*.wav'|sed 's/^/Example\//'|sed 's/.wav/.hungarian.htk/'|xargs -n 1 make
Example/%.hungarian.htk: ./%.wav
	mkdir -p `dirname $@`
	sbatch ./forward.sh `readlink -f $^` `readlink -f $@` hungarian

Example/%.russian.htk: ./%.wav
	mkdir -p `dirname $@`
	sbatch ./forward.sh `readlink -f $^` `readlink -f $@` russian
# Then wait for all queued tasks to finish


# ---- [2] (Fake) Voice Activity Detection (optional) ---
#
#   You might want to run real detection (this one here is wrong!) and store
#   it in a file of the given format
#
Example/%/vad:
	mkdir -p `dirname $@`
	awk ' { print $$1,int(100*$$2),int(100*$$3),int(200*$$3) } ' QUESST2015-dev/boundaries_dev_queries.list | awk '{l=sprintf("%*s",$$2,""); m=sprintf("%*s",$$3,""); n=sprintf("%*s",$$4,""); gsub(/ /,"0",l); gsub(/ /,"1",m); gsub(/ /,"0",n); printf ("%s\t%s%s%s\n",$$1,l,m,n) } ' > $@


# ---- [3] DTW ----
#
#   This is the main part
#
Example/output/hungarian.lab:
	mkdir -p `dirname $@`
	find Example/QUESST2015-dev/Audio        -name '*.hungarian.htk' -exec basename {} .hungarian.htk \; | sort > $@.utts
	find Example/QUESST2015-dev/dev_queries  -name '*.hungarian.htk' -exec basename {} .hungarian.htk \; | sort > $@.dev  || echo "no dev queries"
	find Example/QUESST2015-dev/eval_queries -name '*.hungarian.htk' -exec basename {} .hungarian.htk \; | sort > $@.eval || echo "no eval queries"
	touch $@
#
#   This may take a bit more than 2Gb of RAM per job on avg
# 
# awk ' { printf ("Example/output/%s.lab\n", $0) } ' Example/output/hungarian.lab.utts | xargs -n 1 make
Example/output/%.lab: Example/output/hungarian.lab
	sbatch ./dtw.sh $*
# Wait for all these tasks to finish


# ---- [4] Compute Calibration ----
#
Example/output/calibration.csv:
	rm -f `dirname $@`/system_scores.csv
	find Example/output -name '*.lab' -exec awk ' { sub(".lab", "", FILENAME); sub(".*/", "", FILENAME); print FILENAME,$$3,$$4 } ' {} \; >> `dirname $@`/system_scores.csv
	./scripts_for_participants/BUT_calibration/QUESST14_fusion.py -o $@ \
		-r QUESST2015-dev/quesst2015_dev.csv \
		-w `dirname $@`/all_alphas.betas \
		`dirname $@`/system_scores.csv


# ---- [5] Calibrated Fusion & Detection ----
#
Example/output/fusion.csv:
	./scripts_for_participants/BUT_calibration/QUESST14_fusion.py -o $@ \
		-r QUESST2015-dev/quesst2015_dev.csv \
		-a `dirname $@`/all_alphas.betas \
		-q `dirname $@`/system_scores.csv


# ---- [6] Preparation and Scoring ----
#
Example/output/score.out:
	python 2xml.py
	(cd scoring_quesst2015; ./score-TWV-Cnxe.sh ../Example/output groundtruth_quesst2015_dev -10)
