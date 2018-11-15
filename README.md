# LearningFromDraft
Code associated to the paper https://arxiv.org/abs/1710.01789
---
### Set-up

* The system requirement is specified in <a href="https://github.com/CSLT-THU/CSLT_NMT">CSLT NMT Toolkit</a>. Please follow the instruction to set up the environment.

### Training and testing

#### Introduction

* The training, as specified in the paper, conducts in a two-step manner:
  1. The first step is to train a vanilla NMT model (folder part 1) and generate a draft; 
  2. The second step is to train modified NMT model (folder part 2) where the input is composed of source language sentences and the draft generated from step 1.
* Accordingly, testing also follows this two-step fashion, i.e., first generate a draft using the model in step 1; then generate the final output using the model in step 2 with source language and draft as input.

#### Step-by-step

Clone the repository to your working directory.

```
git clone https://github.com/aodongli/LearningFromDraft.git
```

##### Train

We provide a Chinese-English dataset in './data', with 44,000+ sentences in training set, 1,000+ sentences in development/testing set. The training data corresponds to the small-scale IWSLT dataset mentioned in the paper, but the test data is only part of it.

1) Train a vanilla NMT model using default parameter setting. For detailed description of parameter setting, please refer to <a href="https://github.com/CSLT-THU/CSLT_NMT/blob/master/Manual.pdf">this manual</a>.

```
cd part1
python translate.py
```

2) Suppose you have successfully trained a model and saved it at 10000th checkpoint (<a href="https://www.tensorflow.org/guide/checkpoints">What is a checkpoint?</a>). Then you need to use it to generate the translation draft for step 2. 

```
python translate.py --model translate.ckpt-10000 --decode --beam_size 5 < ../data/train.src > ../data/train.src_2
```

Note that the name of the input file and output file is a MUST.

3) As described in the paper, we use constant word embedding for step 2. Here we extract the embedding from the model we just trained.

```
python translate.py --var_extract --model translate.ckpt-10000
```

If successful,  `emb.src` and `emb.trg` will appear in the main directory.

4) Congratulations! You have done the preparation work for step 2. Do the similar fashion to train part 2.

```
cd part2
python translate.py
```

##### Test

1) Similarly, generate a translation draft of your test sentence.

```
cd part1
python translate.py --model translate.ckpt-10000 --decode --beam_size 5 < ../data/dev.src > ../data/dev.src_2
```

2) The input format for part2 decode is

```
src_sentence_1
draft_1
src_sentence_2
draft_2
...
```

 To generate such a format file, use command `paste` in Linux/Mac. For example,

```
paste -d \\n ./data/dev.src ./data/dev.src_2 > ./data/mix_dev.src
```

3)  Test the result.

```
cd part2
python ./translate.py --model translate.ckpt-10000 --decode --beam_size 5 < ../data/mix_dev.src > ../data/mix_dev_trans
cd ..
perl ./multi-bleu.perl ./data/mix_dev_trans < ./data/dev.trg
```

## Contact

If you have questions, suggestions and bug reports, please email [stamdlee@outlook.com](mailto:stamdlee@outlook.com).



