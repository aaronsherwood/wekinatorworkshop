# Web Browser OSC to Wekinator with TILT!
This example will send OSC from a webpage to Wekinator. It will send mouse X & Y if used on a desktop browser, and it will send two tilt values + touch X & Y if used on on a modile device.

## Usage

* Start the server on you computer with `node server.js`
* All node modules are included
* Set the IP Address in index.html to the IP Address of the computer where the server is running
* Navigate in a browser to `<YOUR_IP_ADDRESS>:8000`
* If using a mobile device set Wekinator to 4 inputs. If using a dekstop browser set Wekinator to 2 inputs (just mouse coords).
