# Citation Rex Website

Citataion Rex is a web-based live demonstration system for context aware citation recommendation based on the Neural Citation Network and using 127 million papers from the MAG. The concept is that users give their sentence(s) for which they require a citation, and the system recommends a list of papers which may fit as a citation to the given context. The model is trained using historical context-citation pairs. Here's a link to the project to train the network: https://github.com/michaelfaerber/NCN4MAG

Depending on branch, the recommendations are displayed with different levels of explainability.

Current link to the master version of the website is: http://km.aifb.kit.edu/services/citerex/#/



# Requirements to build from source

- Flutter
- Web browser (ideally Chrome for development)

The whole system is built using flutter. In order to build the system locally, you need to have a full installation of the Flutter SDK and it's requirements. Full instructions on the installation can be found on their website: https://flutter.dev/docs/get-started/install

Since flutter web is currently still in beta, you need to enable it via the following commands
```
flutter channel beta
flutter upgrade
flutter config --enable-web
```

# Building the website

Flutter allows building for multiple platforms, but we currently only recommend building the web based version. Android and iOS support is theoretically possible, but probably requires fitting the web format to vertical compatibility (as phones have considerably smaller screen sizes).

In order to build the release version with flutter use the following command from the root of the project folder:

```
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
```

The necessary documents used to run the web server are then found in ./web (index.html and javascript files). An example way to run a test HTTP Server can be done by using the python module SimpleHTTPServer (Install using pip if not available). Run the following command from the root of the built web folder:

```
python -m SimpleHTTPServer <port>
```

# Running the backend flask server

First, it is recommended you setup a virtual python3 environment. Then run through the following steps:

- source env/bin/activate (or the absolute path to where you put your env/bin)
- sudo apt-get install python3-pip (if not yet installed)
- pip3 install -r requirements.txt (from ./backend/requirements.txt)
- python -m spacy download en_core_web_lg 

Next, either run this code in the terminal or by creating a .py script:

```
import nltk
nltk.download('stopwords')
```

After that, you need to get the papers' data and train a neural network (assuming you don't already have a model and data that fits). Instructions on how to do that can be found in the following repository: https://github.com/michaelfaerber/NCN4MAG

Once complete, you should have a .pt file (the neural network) and the paper data (either as csv, tsv or txt). Our backend implementation relies on python dictionaries generated from the paper data. You can generate them by running the generate_dictionaries.py script located in the ./backend folder. Just edit the script so that file paths match the location where you saved the paper data.

```
python3 ./backend/generate_dictionaries.py
```

Last but not least execute the ./backend/flaskserver.py file, ensuring the paths in the script lead to the correct file paths. These files are the ones you should have generated in the previous steps:
```
#flaskserver.py
path_to_weights = "./dataset/NCN_5_27_11_embed_128_hid_256_1_GRU.pt"
path_to_data = "./ncn/input/mag_data.csv"
...
with open("assets/title_tokenized_to_full.pkl", "rb") as fp:
    title_to_full = pickle.load(fp)
with open("assets/title_to_aut_cited.pkl", "rb") as fp:
    title_to_aut = pickle.load(fp)
with open("assets/title_tokenized_to_paper_id.pkl", "rb") as fp:
    title_to_paperid = pickle.load(fp)
```
By default the flask server runs on the port 0.0.0.0:5000, but this can also be changed in the flaskserver.py script. 


