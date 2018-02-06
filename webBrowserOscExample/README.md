# Web Browser OSC to Wekinator with TILT!
This example will send OSC from a webpage to Wekinator. It will send mouse X & Y if used on a desktop browser, and it will send two tilt values + touch X & Y if used on on a modile device.

## Usage

* Download and install [Node.js](https://nodejs.org/) if you don't have it already. 
* On the command line, navigate to the folder that contains all the files for the example.
* Start the server: `node server.js`
   - (All node modules are included)
* Set the IP Address in the index.html file to the IP Address of the computer where the server is running
* Navigate in a browser to `<IP_ADDRESS_OF_YOUR_COMPUTER>:8000`
* If using a mobile device set Wekinator to 4 inputs. The first two inputs will be tilt X & Y, the third and fourth will be mouse X & Y. If using a desktop browser set Wekinator to 2 inputs (just mouse coords).
