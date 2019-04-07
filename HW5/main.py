from flask import Flask, jsonify
import requests

app = Flask(__name__)


#  this method returns data (tree health condition) in json format for a given borough and plant as specified in url parameters.

@app.route('/tree/<current_borough>/<current_plant>', methods=['GET'])
def return_tree(current_borough,current_plant):
        url = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' + \
               '$select=health,count(*) *100/ sum(count(*)) over() as proportion' + \
               '&$where=boroname=\'' + current_borough + '\' and spc_common=\'' + current_plant.lower() + '\'' + \
               '&$group=health')
        return getJson(url)


def getJson(url):
    resp = requests.get(url, verify=False)
    return resp.text

if __name__ == '__main__':
    app.run(debug=True)
