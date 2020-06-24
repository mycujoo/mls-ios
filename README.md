# mls-iOS

Because of youbora framework there are only 3 options of SDK shipment:
- Framework itself (youbora should be manualy connected to pod file, but it's everything what should be done)
- Cocoapods
- Carthage

However, SPM nowadays becomes a new dependecy managment stadard for iOS and youbora doesn't support it yet. There are 3 options how to handle this situation and provide customers a possibility to have **mls** as SPM package.
- Just ask Youbora to add support of SPM. It could be treaky for them, because all code in objective-c, but it's the best option.
- Write a wrapper over Youbora API, which used in the **mls**, then **mls** customers can add Youbora as Cocoapods/Carthage and with persisted wrappers add support of Youbora.
- Copy Youbora code into **mls** project. But it will led to tricks with which in SPM should persists Swift and objective-c + every Youbora update have to be done manualy.