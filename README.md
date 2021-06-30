# octobrix
Dockerized octoprint multi-instance environment with multi-webcam support

Context :

In the scope of using octoprint with my 3d printers (I own 4 printers), I was reluctant to buy 4 raspi + cam and set them (for time and cost).
I went for a solution using an old computer, usb cameras and a powered usb port to plug the printers and the camera.
Main idea was to set up a docker server on the computer, create an octoprint container for each printer I own and plug printers + cameras on the usb hub. 




Tested configuration :
- Computer : old gigabyte BRIX J1900 (GB-BXBT-19), 8Gb RAM, SSD 240Gb
- Usb hub : Powered, 10 ports, Acasis
- Usb cameras : MJPG stream (not YUV only stream !) 
