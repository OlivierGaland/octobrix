# octobrix
Dockerized octoprint multi-instance environment with multi-webcam support.

Context :

In the scope of using octoprint with my 3d printers (I own 4 printers), I was reluctant to buy 4 raspi + cam and set them (for time and cost).
I went for a solution using an old computer, usb cameras and a powered usb port to plug the printers and the cameras.
Main idea was to set up a docker server on the computer, create an octoprint container for each printer I own and plug printers + cameras on the usb hub. 

Faced issues :

- Need static /dev links for printers devices : use a custom udev conf file.
- Need static /dev links for cameras : use a custom udev conf file.
- Cannot make more than one low cost usb camera works on the same usb port : need to patch uvc to prevent kernel allowing all bandwidth for a not well designed (cheap) camera. 

Tested configuration :

- Computer : old gigabyte BRIX J1900 (GB-BXBT-19), 8Gb RAM, SSD 240Gb , Ubuntu server 20.04.2 LTS
- Usb hub : Powered, 10 ports, Acasis
- Usb cameras : MJPG (compressed) stream (not YUV only ! they won't work) 
- Camera note : I went for this model (cheap and work) : https://github.com/OlivierGaland/octobrix/blob/main/doc/camera_ok-02.jpg , note that I designed for it a mount that you can fix on 2020 rails : https://cults3d.com/fr/mod%C3%A8le-3d/outil/support-camera-usb-low-cost-pour-profil-2020

Installation procedure :

- Get the hardware 
- Install Ubuntu server 20.04.2 LTS on your computer
- Get octobrix from git repository and run install.sh (warning it involves a kernel recompilation, it tooks 12 hours for me)
- Finalize installation (edit udev configuration and stack.yml to map your printers)
- Start the containers

TODO list :

- I'm not expert in kernel patching and while i wanted just to patch and reinstall uvc, my script end up compiling the whole kernel ! (need an expert looking on that point)
- The uvc_video.c patch does not works on YUV only camera (the very cheap $3 camera found on aliexpress) even removing UVC_FMT_FLAG_COMPRESSED check, i'm pretty sure we can make it works with a better understanding of the code (suspecting others fields than dwMaxPayloadTransferSize need to be altered).
- Implement auto switch on/off through PSU Control
- Write a tutorial for custom udev rules (people knowing a little can check the /files/ directory and easily writes their own rules to map a static /dev item mapping usb hub port number) 

Contact :

- If you want to contact me , or give a few bucks through paypal if you find this project usefull, my email is : galand.olivier.david@gmail.com 
