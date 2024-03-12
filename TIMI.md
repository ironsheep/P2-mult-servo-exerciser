# P2 TIMI Spin2 Object
A reusable object written in spin2 for driving the TIMI serial IPS LCD-TFT displays.

![Project Maintenance][maintenance-shield]

[![License][license-shield]](LICENSE)

[Breadboard Mates (BBM)](https://breadboardmates.com/) produces the TIMI line of displays. These are similar to teh Nextion devices we've seen in that we select the screens to be displayed and upload them to the device (essentially flashing the device.) Then we connect the device containing the screens to our project via serial and simply send values to the screen fields or labels. 


## Table of Contents

On this Page:

- [The Hardware](#the-hardware)
- [The Public Interface](#the-timi-object-public-interface)
- [The Source Code](#the-source-code)

Additional pages:

- [Enclosing Project README](./README.md) - The top level documentation for the overall project
- [The rotary Encoder object](./RotaryEnc.md) - Reusable object for reading rotary encoder with push button
- [The TIMI-130 Datasheet](./Docs/TIMI-130_Datasheet_REV1.0.pdf) 
- [Breadboard Mates Products](https://breadboardmates.com/products/) - shop the full line of products
- [Mates Studio](https://breadboardmates.com/products/mates-studio/) - The windows software for programming the TIMI devices


## The Hardware

Here is the [TIMI-130](https://breadboardmates.com/products/timi-130/) I'm using for this project:

![](./DOCs/images/timi-130-features-image-new-1-e1632995287139.png)


## The TIMI object PUBLIC Interface

The object **isp\_timi_mates.spin2** when first started configures the serial pins at the requested baud rate [Default: 9600]. 

The object provides the following methods for starting up, tearing down and accessing the values read from the device and writing values to the device:

| OBJECT Interface | Description |
| --- | --- |
|  **>--- SETUP**
| PUB  start(pinTx, pinRx, pinReset, baudRate) : bDidSucceed | Start simple serial comms on given pins at baudrate
| PUB  stop() | Stop underlying serial device and release pins
| PUB  error() : latestError | Return latest Mates Error Code
| PUB  hardReset() : bDidSucceed | Uses hardware driven signal to hard reset Timi device<br> Returns the boolean response from the reset
| PUB  softReset() : bDidSucceed | Sends a serial command to the connected Timi device to trigger a reset<br> Returns the boolean response from the reset
| PUB  setBacklight(backlightValue) : bDidSucceed | Sets the intensity of the backlight of connected device: where {backlightValue} is [0-255]<br> Returns the boolean response from the backlight command
|  **>--- Normal Interaction**
| PUB  setPage(pageIndex, timeout) : bDidSucceed | Sets the page to be displayed on the connected device<br> Returns T/F where T indicates success
| PUB  getPage() : pageIdx | Returns {pageIdx} the index of the current page displayed by the connected device
| PUB  setWidgetValueById(widgetId, widgetValue) : bDidSucceed | Sets the value of a specific widget based on the provided identifier<br> Returns T/F where T indicates success
| PUB  getWidgetValueById(widgetId) : widgetValue | Gets the value of a widget based on the {widgetId}<br> Returns {widgetValue} an integer corresponding to widget value.
| <PRE>PUB  setWidgetValueByIndex(widgetType, widgetIndex, widgetValue) : bDidSucceed</PRE> | Sets the value of a specific widget based on the index within a widget type<br> Returns T/F where T indicates success
| PUB  getWidgetValueByIndex(widgetType, widgetIndex) : widgetValue | Gets the value of a specific widget based on the index within a widget type<br> Returns {widgetValue} an integer corresponding to widget value.
| PUB  setLedDigitsShortValue(widgetIndex, widgetValue) : bDidSucceed | Sets the value of specifically int16 LED Digits widgets based on the widget index<br> Returns T/F where T indicates success
| PUB  setLedDigitsLongValue(widgetIndex, widgetValue) : bDidSucceed | Sets the value of specifically int32 LED Digits widgets based on the widget index<br> Returns T/F where T indicates success
| PUB  setLedDigitsFloatValue(widgetIndex, floatWidgetValue) : bDidSucceed | Sets the value of specifically float32 LED Digits widgets based on the widget index<br> Returns T/F where T indicates success
| PUB  setSpectrumValue(spectrumId, gaugeIndex, widgetValue) : bDidSucceed | Sets the value of specifically Spectrum widgets based the spectrum id and gauge index<br> Returns T/F where T indicates success
| PUB  setLedSpectrumValue(ledSpectrumIndex, gaugeIndex, widgetValue) : bDidSucceed | Sets the value of specific LED Spectrum widgets based on the gauge index<br> Returns T/F where T indicates success
| PUB  setMediaSpectrumValue(mediaIndex, gaugeIndex, widgetValue) : bDidSucceed | Sets the value of specific Media Spectrum widgets based on the Media Spectrum index and the gauge index<br> Returns T/F where T indicates success
| PUB  setWidgetParamById(widgetId, param, widgetValue) : bDidSucceed | Sets the value of a widget parameter based on widget id and parameter id<br> Returns T/F where T indicates success
| PUB  getWidgetParamById(widgetId, param) : targetParamValue | Gets the value of a widget parameter based on widget id and parameter id<br> Returns and integer containing the target parameter value.
| PUB  setWidgetParamByIndex(widgetType, widgetIndex, param, widgetValue) : bDidSucceed | Sets the value of a widget parameter based on widget index and parameter id<br> Returns T/F where T indicates success
| PUB  getWidgetParamByIndex(widgetType, widgetIndex, param) : widgetValue | Gets the value of a widget parameter based on widget index and parameter id<br> Returns {widgetValue} the target parameter value
| PUB  clearTextArea(textAreaIndex) : bDidSucceed | Clears a targeted Text Area<br> Returns T/F where T indicates success
| PUB  updateTextArea(textAreaIndex, pString) : bDidSucceed | Updates the text displayed within Text Area widget<br> Returns T/F where T indicates success
| PUB  clearPrintArea(printAreaIndex) : bDidSucceed | Clears a targeted Print Area<br> Returns T/F where T indicates success
| PUB  setPrintAreaColor565(printAreaIndex, rgb565Value) : bDidSucceed | Sets the color of a PrintArea Widget based on an rgb565 value<br> Returns T/F where T indicates success
| PUB  setPrintAreaColorRGB(printAreaIndex, redValue, greenValue, blueValue) : bDidSucceed | Sets the color of a PrintArea Widget<br> Returns T/F where T indicates success
| PUB  appendArrayToPrintArea(printAreaIndex, pBytes, byteCount) : bDidSucceed | Appends {pBytes} a list of integers to the {printAreaIndex} Print Area widget<br> Returns T/F where T indicates success
| PUB  appendStringToPrintArea(printAreaIndex, pString) : bDidSucceed | Appends {pString} to the {printAreaIndex} Print Area widget<br>  Returns T/F where T indicates success
| PUB  appendToScopeWidget(scopeIndex, pWordBuffer, countWords) : bDidSucceed | Appends {pWordBuffer} a list of integers to the {scopeIndex} Scope widget<br> Returns T/F where T indicates success
| PUB  updateDotMatrixWidget(matrixIndex, pString) : bDidSucceed | Writes {pString} to the {matrixIndex} Dot Matrix widget<br> Returns T/F where T indicates success
| PUB  getButtonEventCount() : countButtonEvents | Gets the number of events recorded from applicable button widgets<br> Returns {countButtonEvents} the number of events recorded
| PUB  getNextButtonEvent() : widgetId | Gets the next event source logged from applicable buttons<br> Returns {widgetId} an integer corresponding to the button widget ID
| PUB  getSwipeEventCount() : eventCount | Gets the number of events recorded from swipe gestures<br> Returns {eventCount} an integer corresponding to the number of events
| PUB  getNextSwipeEvent() : swipeEvent |  Gets the next swipe event value<br> Returns {swipeEvent} an integer corresponding to the swipe event
| PUB  getVersion() : pVerString | Helper function to obtain the version of the Python Mates Controller library<br> Returns {pVerString} string response of library version
| PUB  getCompatibility() : pVerString | Helper function to obtain the version of the Mates Studio compatible with this library version<br> Returns {pVerString} string response of Mates Studio version compatible with this library
| PUB  printVersion() | Debugging function to print the version of the Mates Studio compatible along with this specific library version.
| PUB  getError() : latestError | Helper function to obtain the current error state of the Mates Controller<br> Returns {latestError} MatesError response of current error
|  **>--- NOT Implemented**
| PUB  setBufferSize(size) | setBufferSize(size) NOT Implemented!!
| PUB  takeScreenshot() : bDidSucceed, pImage | takeScreenshot() NOT Implemented!!
| PUB  saveScreenshot(pFilenameStr) : bDidSave | saveScreenshot() NOT Implemented!!


## The Source Code

The following files comprise our driver source code:

| Filename | Purpose | Description |
| --- | --- | --- |
| **Driver FILEs**
| [isp\_timi_mates.spin2](isp_timi_mates.spin2) | DRIVER | the TIMI Driver object
| [isp\_serial.spin2](isp_serial.spin2) | DRIVER | underlying serial HW interface
| [jm\_nstring.spin2](jm_ez_spi.spin2) | DRIVER | string formatting routines (fm JonnyMac)


---

> If you like my work and/or this has helped you in some way then feel free to help me out for a couple of :coffee:'s or :pizza: slices!
>
> [![coffee](https://www.buymeacoffee.com/assets/img/custom_images/black_img.png)](https://www.buymeacoffee.com/ironsheep) &nbsp;&nbsp; -OR- &nbsp;&nbsp; [![Patreon](./DOCs/images/patreon.png)](https://www.patreon.com/IronSheep?fan_landing=true)[Patreon.com/IronSheep](https://www.patreon.com/IronSheep?fan_landing=true)

---

## Disclaimer and Legal

> *Parallax, Propeller Spin, and the Parallax and Propeller Hat logos* are trademarks of Parallax Inc., dba Parallax Semiconductor
>
> This project is a community project not for commercial use.
>
> This project is in no way affiliated with, authorized, maintained, sponsored or endorsed by *Parallax Inc., dba Parallax Semiconductor* or any of its affiliates or subsidiaries.

---

## License

Copyright © 2023 Iron Sheep Productions, LLC. All rights reserved.

Licensed under the MIT License.

Follow these links for more information:

### [Copyright](copyright) | [License](LICENSE)

[maintenance-shield]: https://img.shields.io/badge/maintainer-stephen%40ironsheep%2ebiz-blue.svg?style=for-the-badge

[license-shield]: https://camo.githubusercontent.com/bc04f96d911ea5f6e3b00e44fc0731ea74c8e1e9/68747470733a2f2f696d672e736869656c64732e696f2f6769746875622f6c6963656e73652f69616e74726963682f746578742d646976696465722d726f772e7376673f7374796c653d666f722d7468652d6261646765
