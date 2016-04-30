# DNNbasedTTS-BTP

A Speech Synthesizer using Deep Neural Nets.

Requirements :
	Festival: http://festvox.org/festival/
	SPTK: http://sp-tk.sourceforge.net/
	HTS: http://hts.sp.nitech.ac.jp/
	hts_engine API: http://hts-engine.sourceforge.net/
	STRAIGHT

ALL Steps For Acoustic feature extraction ::

Download CMU-arctic database :
Convert all .raw files to .wav files using a bash script. I have stored the bash script in data/scripts/soxRW.sh
Saved to “wav” folder
Extract mfcc features for all wavs. Saved to “acousticFeats” folder
Mfcc - 40 features for 1 frame - using mfcc_straight.m function
log(f0)  - using straight
Band aperidiocities - 5 

Checkout for which voice is used to generate utt in cmu_artic_stl and then use the same for featExtract.p.**
Then check no. of frames (if same or not)
Then add features for the frames.


-- > Suggestions: remove all unvoiced frames and remove “pau” from the labels to get a mapping from input frames to output frames. 
→ Checkout Kaldi if it is able to do the same. 


“””””””””””””””” Installation Instruction for HTS-demo-Databse” “”””””””””””””””””””””””””””””””””
Download latest HTS-demo from http://hts.sp.nitech.ac.jp/archives/2.3/HTS-demo_CMU-ARCTIC-SLT.tar.bz2
Specify the path for 
festival/examples
SPTK-3.9 binaries
HTS2.3 
Download HTS2.3forHTS3.4.1 , follow instructions 
Install fortain in ubuntu (sudo apt-get install gfortran)
./configre -> make -> make install
Festival-api1.10
( ./configure    --with-fest-search-path=/home/ashish/Downloads/festival-master/examples \                 --with-sptk-search-path=/home/ashish/Downloads/SPTK-3.9/bin \ --with-hts-search-path=/usr/local/HTS-2.3/bin \         --with-hts-engine-search-path=/usr/local/bin 	)




