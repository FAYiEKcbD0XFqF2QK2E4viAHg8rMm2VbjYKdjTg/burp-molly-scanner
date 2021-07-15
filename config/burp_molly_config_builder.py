# Script to generate molly config to scan a given url from command line args!

from jinja2 import Template
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-r", "--report_path", help = "Report output path")
parser.add_argument("-u", "--initial_url", help = "Initial url to scan")
parser.add_argument("-t", "--scan_timeout", help = "Scan timeout")
args = parser.parse_args()

with open('./config/burp_molly_config.jinja') as file_:
  template = Template(file_.read())

print(template.render(report_path=args.report_path, initial_url=args.initial_url, scan_timeout=args.scan_timeout))