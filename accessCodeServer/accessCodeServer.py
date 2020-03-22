# -*- coding: utf-8 -*-

import random
from http.server import HTTPServer, BaseHTTPRequestHandler
import xml.etree.ElementTree as ET
from urllib.parse import urlparse
import sys

response_string0 = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><title>CallMyContacts - Corona Warnnachricht</title></head><body>Hier werden die Codes vergeben.<br><br><form action='/' method='post'><label for='warningMessage'>Zusätzliche Hinweise</label><br><textarea name='warningMessage' rows='2' id='warningMessage' placeholder='In diesem Feld können Hinweise bezüglich der lokalen Umstände gegeben werden ...' cols='20' style='width: 30%; height: 100px;'></textarea><br><br><input type='submit' value='Generiere Zugangscode'></form><p id='accessCode'>"
response_string1 = "</p></body></html>"

class Serv(BaseHTTPRequestHandler):

    def do_GET(self):

        if self.path == "/":
            self.path = "/index.html"

        if self.path == "/index.html":
            with open(self.path[1:], 'rb') as file:
                self.send_response(200)
                self.send_header("content-type", "text/html; charset=UTF-8")
                self.end_headers()
                self.wfile.write(file.read())

        elif self.path == "/requests.js":
            with open(self.path[1:], 'rb') as file:
                self.send_response(200)
                self.send_header("content-type", "text/javascript; charset=UTF-8")
                self.end_headers()
                self.wfile.write(file.read())

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(bytes("404:" + self.path + "does not exist or may not be accessed", 'utf-8'))

    def do_POST(self):

        if self.path != "/":
            self.send_response(404)
            self.end_headers()
            self.wfile.write(bytes("404:" + self.path + " does not exist or is not accessible by a POST request", 'utf-8'))

        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)

        fields = urlparse(body).path.decode("utf-8")

        xml_response = bytes("empty", 'utf-8')
        if fields.startswith("warningMessage="):
            content = fields[len("warningMessage="):]
            rand = str(random.randrange(0, 100000, 1))
            access_code = str(hash(content + rand))[-6:]

            store_new_code(access_code, content)
            xml_response = bytes(response_string0 + access_code + response_string1, 'utf-8')


        self.send_response(200)
        self.send_header("content-type", "text/html; charset=UTF-8")
        self.end_headers()
        self.wfile.write(xml_response)


def store_new_code(access_code, content):
    xml_code_list = ET.parse('accessCodes.xml')
    root_node = xml_code_list.getroot()

    ET.SubElement(root_node, "accessCode", {'content': content, 'access_code': access_code})
    xml_code_list.write('accessCodes.xml')


ip_address = sys.argv[1]
httpd = HTTPServer((ip_address, 8080), Serv)
httpd.serve_forever()