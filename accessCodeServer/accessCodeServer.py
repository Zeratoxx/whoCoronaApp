import random
from http.server import HTTPServer, BaseHTTPRequestHandler
import xml.etree.ElementTree as ET

import requests


def perform_trip_request(xml_parameters):
    first = True
    base_url = "https://www.rmv.de/hapi/trip?"
    for child in xml_parameters:
        if not first:
            base_url += "&"
        else:
            first = False
        parameter_name = str(child.tag)
        base_url += parameter_name
        base_url += "="
        base_url += str(child.text)

    r = requests.get(url=base_url)
    return r.content


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

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(bytes("404:" + self.path + "does not exist or may not be accessed", 'utf-8'))

    def do_POST(self):

        if self.path != "/index.html":
            self.send_response(404)
            self.end_headers()
            self.wfile.write(bytes("404:" + self.path + " does not exist or is not accessible by a POST request", 'utf-8'))

        content_length = int(self.headers['Content-Length'])
        body = str(self.rfile.read(content_length))[2:-1]
        xml_body = ET.fromstring(body)
        request_type = xml_body.attrib["type"]

        xml_response = bytes("empty", 'utf-8')
        if request_type == "accessCode":
            content = xml_body.text
            rand = str(random.randrange(0, 1000000, 1))
            accessCode = str(hash(content + rand))[-6:]

            xml_response = bytes("<accessCode>" + accessCode + "</accessCode>", 'utf-8')

        self.send_response(200)
        self.send_header("content-type", "text/xml; charset=UTF-8")
        self.end_headers()
        self.wfile.write(xml_response)


httpd = HTTPServer(('localhost', 8080), Serv)
httpd.serve_forever()