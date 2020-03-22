# -*- coding: utf-8 -*-

import random
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
import xml.etree.ElementTree as ET
from urllib.parse import urlparse

response_string0 = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><title>CallMyContacts - Corona Warnnachricht</title></head><body style='background-color: #454545; margin: 0px; font-family: Verdana, Geneva, sans-serif;'><div style='background-color: #f0efe9; position: relative; top: 10vh; height: 85vh; padding: 30px'><div style='position: relative; left: 25%; width: 50%; height: 90%; background-color: white; padding-top: 50px'><h1 style='text-align: center'>Zugriffscodes</h1><p style='text-align: center'>Hier werden die Codes vergeben.<p></p><br><br><form action='/' method='post'><label for='warningMessage' style='margin-left: 10%;'>Zusätzliche Hinweise</label><br><textarea name='warningMessage' rows='2' id='warningMessage' placeholder='In diesem Feld können Hinweise bezüglich der lokalen Umstände angegeben werden ...' cols='20' style='margin-left: 10%; width: 80%; font-size: 16px; height: 170px;'></textarea><br><br><input type='submit' value='Generiere Zugangscode' style='padding: 10px;'><p id='accessCode' style='float: left; position: relative; left: 30%; margin-top: 12px; width: 10%'>"
response_string1 = "</p></form></div></div></body></html>"

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

        xml_response = bytes("empty", 'utf-8')

        if self.path == "/access_request":
            content_length = int(self.headers['Content-Length'])
            access_code = self.rfile.read(content_length).decode("utf-8")

            if not access_code.startswith("access_code="):
                self.send_response(404)
                self.end_headers()
                self.wfile.write(bytes("The requested access code is invalid.", 'utf-8'))
                return

            content = get_access_code_entry(access_code[len("access_code="):])

            if content == None:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(bytes("The requested access code is invalid.", 'utf-8'))
                return

            xml_response = bytes(content, 'utf-8')

        elif self.path != "/":
            self.send_response(404)
            self.end_headers()
            self.wfile.write(bytes("404:" + self.path + " does not exist or is not accessible by a POST request", 'utf-8'))

        else:
            content_length = int(self.headers['Content-Length'])
            body = self.rfile.read(content_length)

            fields = urlparse(body).path.decode("utf-8")

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

    ET.SubElement(root_node, 'tag_' + access_code, {'content': content})
    xml_code_list.write('accessCodes.xml')


def get_access_code_entry(access_code):
    xml_code_list = ET.parse('accessCodes.xml')
    root_node = xml_code_list.getroot()
    access_code_node = root_node.find('tag_' + access_code)

    if access_code_node == None:
        return None

    content = access_code_node.get('content')
    root_node.remove(access_code_node)
    xml_code_list.write('accessCodes.xml')

    return content


ip_address = sys.argv[1]
httpd = HTTPServer((ip_address, 8080), Serv)
# httpd = HTTPServer(('localhost', 8080), Serv)
httpd.serve_forever()