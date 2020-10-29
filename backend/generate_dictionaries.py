# In[1]:

import pickle
import pandas as pd
import random
import re
import spacy
import string
from typing import List, Set
from functools import partial
from spacy.tokenizer import Tokenizer
from torchtext.data import Field, BucketIterator, Dataset, TabularDataset
from ncn.data import get_mag_data, prepare_mag_data

import numpy as np
import nltk
import logging

# In[3]:

logging.basicConfig(level=logging.INFO, style='$')
logger = logging.getLogger("neural_citation")
"""Base logger for the neural citation package."""

# In[4]:


nlp = spacy.load("en_core_web_lg")
tokenizer = Tokenizer(nlp.vocab)


# In[5]:


def get_stopwords() -> Set:
    """
    Returns spacy and nltk stopwords unified into a single set.   

    ## Output:  

    - **STOPWORDS** *(Set)*: Set containing the stopwords for preprocessing 
    """
    STOPWORDS = spacy.lang.en.stop_words.STOP_WORDS
    nltk_stopwords = set(nltk.corpus.stopwords.words('english'))
    STOPWORDS.update(nltk_stopwords)
    return STOPWORDS


# In[6]:


STOPWORDS = get_stopwords()


# In[7]:


def title_context_preprocessing(text: str, tokenizer: Tokenizer, identifier: str) -> List[str]:
    """
    Applies the following preprocessing steps on a string:  

    1. Replace digits
    2. Remove all punctuation.  
    3. Tokenize.  
    4. Remove numbers.  
    5. Lemmatize.   
    6. Remove blanks  
    7. Prune length to max length (different for contexts and titles)  

    ## Parameters:  

    - **text** *(str)*: Text input to be processed.  
    - **tokenizer** *(spacy.tokenizer.Tokenizer)*: SpaCy tokenizer object used to split the string into tokens.      
    - **identifier** *(str)*: A string determining whether a title or a context is passed as text.  


    ## Output:  

    - **List of strings**:  List containing the preprocessed tokens.
    """
    text = re.sub("\d*?", '', text)
    text = re.sub("[" + re.escape(string.punctuation) + "]", " ", text)
    text = [token.lemma_ for token in tokenizer(text) if not token.like_num]
    text = [token for token in text if token.strip()]

    # return the sequence up to max length or totally if shorter
    # max length depends on the type of processed text
    if identifier == "context":
        try:
            return text[:100]
        except IndexError:
            return text
    elif identifier == "title_cited":
        try:
            return text[:30]
        except IndexError:
            return text
    else:
        raise NameError("Identifier name could not be found.")


def author_preprocessing(text: str) -> List[str]:
    """
    Applies the following preprocessing steps on a string:  


    1. Remove all numbers.   
    2. Tokenize.  
    3. Remove blanks.  
    4. Prune length to max length. 

    ## Parameters:  

    - **text** *(str)*: Text input to be processed.  

    ## Output:  

    - **List of strings**:  List containing the preprocessed author tokens. 
    """
    text = re.sub("\d*?", '', text)
    text = text.split(',')
    text = [token.strip() for token in text if token.strip()]

    # return the sequence up to max length or totally if shorter
    try:
        return text[:5]
    except IndexError:
        return text


# In[8]:


STOPWORDS = get_stopwords()
cntxt_tokenizer = partial(title_context_preprocessing,
                          tokenizer=tokenizer, identifier="context")
ttl_tokenizer = partial(title_context_preprocessing,
                        tokenizer=tokenizer, identifier="title_cited")

# instantiate fields preprocessing the relevant data
TTL = Field(tokenize=ttl_tokenizer,
            stop_words=STOPWORDS,
            init_token='<sos>',
            eos_token='<eos>',
            lower=True)

AUT = Field(tokenize=author_preprocessing, batch_first=True, lower=True)

CNTXT = Field(tokenize=cntxt_tokenizer, stop_words=STOPWORDS,
              lower=True, batch_first=True)


# In[9]:


logger.info("Getting fields...")
# generate torchtext dataset from a .csv given the fields for each datatype
# has to be single dataset in order to build proper vocabularies
logger.info("Loading dataset...")
dataset = TabularDataset("./dataset/mag_data.tsv", "TSV",
                         [("context", CNTXT), ("authors_citing", AUT),
                          ("title_cited", TTL), ("authors_cited", AUT)],
                         skip_header=True)

# build field vocab before splitting data
logger.info("Building vocab...")
TTL.build_vocab(dataset, max_size=20000)
AUT.build_vocab(dataset, max_size=20000)
CNTXT.build_vocab(dataset, max_size=20000)


# In[10]:


examples = dataset.examples


# In[11]:


len(examples)


# In[12]:


# In[13]:


def get_aut_matchings(examples):
    mapping = {}
    for example in examples:
        key = tuple(example.title_cited)
        if key not in mapping.keys():
            mapping[key] = example.authors_cited

    return mapping


# In[14]:


mapping_aut = get_aut_matchings(examples)


# In[15]:


with open("./assets/title_to_aut_cited.pkl", "wb") as fp:
    pickle.dump(mapping_aut, fp)


# In[16]:


dat = pd.read_csv("./dataset/mag_data.tsv", sep="\t")


# In[17]:


dat["ttl_proc"] = dat["title_cited"].map(lambda x: TTL.preprocess(x))


# In[18]:


dat[["ttl_proc", "title_cited"]].head(10)


# In[19]:


def title_to_full(data):
    mapping = {}
    for index in data.index:
        key = " ".join(data.iloc[index, 4])
        if key not in mapping.keys():
            mapping[key] = data.iloc[index, 2]

    return mapping


# In[20]:


mapping_titles = title_to_full(dat)


# In[21]:


with open("./assets/title_tokenized_to_full.pkl", "wb") as fp:
    pickle.dump(mapping_titles, fp)

# In[22]:

mag_df = pd.read_csv('./dataset/mag_all.txt', sep="\t")

totalLen = len(mag_df)

idMapping = {}

for index, row in mag_df.iterrows():
    paper_id = row['paperid']
    title = row['papertitle']
    if title not in idMapping.keys():
        idMapping[title] = paper_id
    print("Progress: " + str(index/totalLen))

with open("assets/title_tokenized_to_paper_id.pkl", "wb") as fp:
    pickle.dump(idMapping, fp)
