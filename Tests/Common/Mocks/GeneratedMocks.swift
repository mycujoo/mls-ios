// MARK: - Mocks generated from file: Sources/App/Utils/MLSAVPlayerProtocol.swift at 2020-07-28 10:41:30 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import AVFoundation
import Foundation


 class MockMLSAVPlayerProtocol: MLSAVPlayerProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = MLSAVPlayerProtocol
    
     typealias Stubbing = __StubbingProxy_MLSAVPlayerProtocol
     typealias Verification = __VerificationProxy_MLSAVPlayerProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSAVPlayerProtocol?

     func enableDefaultImplementation(_ stub: MLSAVPlayerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var status: AVPlayer.Status {
        get {
            return cuckoo_manager.getter("status",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.status)
        }
        
    }
    
    
    
     var isMuted: Bool {
        get {
            return cuckoo_manager.getter("isMuted",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isMuted)
        }
        
        set {
            cuckoo_manager.setter("isMuted",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isMuted = newValue)
        }
        
    }
    
    
    
     var currentItem: AVPlayerItem? {
        get {
            return cuckoo_manager.getter("currentItem",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItem)
        }
        
    }
    
    
    
     var currentDuration: Double {
        get {
            return cuckoo_manager.getter("currentDuration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDuration)
        }
        
    }
    
    
    
     var currentTime: Double {
        get {
            return cuckoo_manager.getter("currentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentTime)
        }
        
    }
    
    
    
     var optimisticCurrentTime: Double {
        get {
            return cuckoo_manager.getter("optimisticCurrentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.optimisticCurrentTime)
        }
        
    }
    
    
    
     var isSeeking: Bool {
        get {
            return cuckoo_manager.getter("isSeeking",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isSeeking)
        }
        
    }
    

    

    
    
    
     func play()  {
        
    return cuckoo_manager.call("play()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.play())
        
    }
    
    
    
     func pause()  {
        
    return cuckoo_manager.call("pause()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.pause())
        
    }
    
    
    
     func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)  {
        
    return cuckoo_manager.call("addObserver(_: NSObject, forKeyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)",
            parameters: (observer, keyPath, options, context),
            escapingParameters: (observer, keyPath, options, context),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.addObserver(observer, forKeyPath: keyPath, options: options, context: context))
        
    }
    
    
    
     func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any {
        
    return cuckoo_manager.call("addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) -> Any",
            parameters: (interval, queue, block),
            escapingParameters: (interval, queue, block),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: block))
        
    }
    
    
    
     func removeTimeObserver(_ observer: Any)  {
        
    return cuckoo_manager.call("removeTimeObserver(_: Any)",
            parameters: (observer),
            escapingParameters: (observer),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeTimeObserver(observer))
        
    }
    
    
    
     func removeObserver(_ observer: NSObject, forKeyPath keyPath: String)  {
        
    return cuckoo_manager.call("removeObserver(_: NSObject, forKeyPath: String)",
            parameters: (observer, keyPath),
            escapingParameters: (observer, keyPath),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeObserver(observer, forKeyPath: keyPath))
        
    }
    
    
    
     func replaceCurrentItem(with item: AVPlayerItem?)  {
        
    return cuckoo_manager.call("replaceCurrentItem(with: AVPlayerItem?)",
            parameters: (item),
            escapingParameters: (item),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.replaceCurrentItem(with: item))
        
    }
    
    
    
     func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler))
        
    }
    
    
    
     func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    
    
    
     func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(by: amount, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    

	 struct __StubbingProxy_MLSAVPlayerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var status: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, AVPlayer.Status> {
	        return .init(manager: cuckoo_manager, name: "status")
	    }
	    
	    
	    var isMuted: Cuckoo.ProtocolToBeStubbedProperty<MockMLSAVPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted")
	    }
	    
	    
	    var currentItem: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, AVPlayerItem?> {
	        return .init(manager: cuckoo_manager, name: "currentItem")
	    }
	    
	    
	    var currentDuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration")
	    }
	    
	    
	    var currentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentTime")
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime")
	    }
	    
	    
	    var isSeeking: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isSeeking")
	    }
	    
	    
	    func play() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "play()", parameterMatchers: matchers))
	    }
	    
	    func pause() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "pause()", parameterMatchers: matchers))
	    }
	    
	    func addObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(_ observer: M1, forKeyPath keyPath: M2, options: M3, context: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(NSObject, String, NSKeyValueObservingOptions, UnsafeMutableRawPointer?)> where M1.MatchedType == NSObject, M2.MatchedType == String, M3.MatchedType == NSKeyValueObservingOptions, M4.OptionalMatchedType == UnsafeMutableRawPointer {
	        let matchers: [Cuckoo.ParameterMatcher<(NSObject, String, NSKeyValueObservingOptions, UnsafeMutableRawPointer?)>] = [wrap(matchable: observer) { $0.0 }, wrap(matchable: keyPath) { $0.1 }, wrap(matchable: options) { $0.2 }, wrap(matchable: context) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "addObserver(_: NSObject, forKeyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)", parameterMatchers: matchers))
	    }
	    
	    func addPeriodicTimeObserver<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(forInterval interval: M1, queue: M2, using block: M3) -> Cuckoo.ProtocolStubFunction<(CMTime, DispatchQueue?, (CMTime) -> Void), Any> where M1.MatchedType == CMTime, M2.OptionalMatchedType == DispatchQueue, M3.MatchedType == (CMTime) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, DispatchQueue?, (CMTime) -> Void)>] = [wrap(matchable: interval) { $0.0 }, wrap(matchable: queue) { $0.1 }, wrap(matchable: block) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) -> Any", parameterMatchers: matchers))
	    }
	    
	    func removeTimeObserver<M1: Cuckoo.Matchable>(_ observer: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Any)> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: observer) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "removeTimeObserver(_: Any)", parameterMatchers: matchers))
	    }
	    
	    func removeObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ observer: M1, forKeyPath keyPath: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(NSObject, String)> where M1.MatchedType == NSObject, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(NSObject, String)>] = [wrap(matchable: observer) { $0.0 }, wrap(matchable: keyPath) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "removeObserver(_: NSObject, forKeyPath: String)", parameterMatchers: matchers))
	    }
	    
	    func replaceCurrentItem<M1: Cuckoo.OptionalMatchable>(with item: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AVPlayerItem?)> where M1.OptionalMatchedType == AVPlayerItem {
	        let matchers: [Cuckoo.ParameterMatcher<(AVPlayerItem?)>] = [wrap(matchable: item) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "replaceCurrentItem(with: AVPlayerItem?)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, completionHandler: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: completionHandler) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(by amount: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(Double, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == Double, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: amount) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_MLSAVPlayerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var status: Cuckoo.VerifyReadOnlyProperty<AVPlayer.Status> {
	        return .init(manager: cuckoo_manager, name: "status", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isMuted: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItem: Cuckoo.VerifyReadOnlyProperty<AVPlayerItem?> {
	        return .init(manager: cuckoo_manager, name: "currentItem", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentDuration: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentTime: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "currentTime", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isSeeking: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isSeeking", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func play() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("play()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func pause() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("pause()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func addObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(_ observer: M1, forKeyPath keyPath: M2, options: M3, context: M4) -> Cuckoo.__DoNotUse<(NSObject, String, NSKeyValueObservingOptions, UnsafeMutableRawPointer?), Void> where M1.MatchedType == NSObject, M2.MatchedType == String, M3.MatchedType == NSKeyValueObservingOptions, M4.OptionalMatchedType == UnsafeMutableRawPointer {
	        let matchers: [Cuckoo.ParameterMatcher<(NSObject, String, NSKeyValueObservingOptions, UnsafeMutableRawPointer?)>] = [wrap(matchable: observer) { $0.0 }, wrap(matchable: keyPath) { $0.1 }, wrap(matchable: options) { $0.2 }, wrap(matchable: context) { $0.3 }]
	        return cuckoo_manager.verify("addObserver(_: NSObject, forKeyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func addPeriodicTimeObserver<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(forInterval interval: M1, queue: M2, using block: M3) -> Cuckoo.__DoNotUse<(CMTime, DispatchQueue?, (CMTime) -> Void), Any> where M1.MatchedType == CMTime, M2.OptionalMatchedType == DispatchQueue, M3.MatchedType == (CMTime) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, DispatchQueue?, (CMTime) -> Void)>] = [wrap(matchable: interval) { $0.0 }, wrap(matchable: queue) { $0.1 }, wrap(matchable: block) { $0.2 }]
	        return cuckoo_manager.verify("addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) -> Any", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeTimeObserver<M1: Cuckoo.Matchable>(_ observer: M1) -> Cuckoo.__DoNotUse<(Any), Void> where M1.MatchedType == Any {
	        let matchers: [Cuckoo.ParameterMatcher<(Any)>] = [wrap(matchable: observer) { $0 }]
	        return cuckoo_manager.verify("removeTimeObserver(_: Any)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeObserver<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ observer: M1, forKeyPath keyPath: M2) -> Cuckoo.__DoNotUse<(NSObject, String), Void> where M1.MatchedType == NSObject, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(NSObject, String)>] = [wrap(matchable: observer) { $0.0 }, wrap(matchable: keyPath) { $0.1 }]
	        return cuckoo_manager.verify("removeObserver(_: NSObject, forKeyPath: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func replaceCurrentItem<M1: Cuckoo.OptionalMatchable>(with item: M1) -> Cuckoo.__DoNotUse<(AVPlayerItem?), Void> where M1.OptionalMatchedType == AVPlayerItem {
	        let matchers: [Cuckoo.ParameterMatcher<(AVPlayerItem?)>] = [wrap(matchable: item) { $0 }]
	        return cuckoo_manager.verify("replaceCurrentItem(with: AVPlayerItem?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, completionHandler: M4) -> Cuckoo.__DoNotUse<(CMTime, CMTime, CMTime, (Bool) -> Void), Void> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: completionHandler) { $0.3 }]
	        return cuckoo_manager.verify("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.__DoNotUse<(CMTime, CMTime, CMTime, Double, (Bool) -> Void), Void> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return cuckoo_manager.verify("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(by amount: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.__DoNotUse<(Double, CMTime, CMTime, Double, (Bool) -> Void), Void> where M1.MatchedType == Double, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: amount) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return cuckoo_manager.verify("seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class MLSAVPlayerProtocolStub: MLSAVPlayerProtocol {
    
    
     var status: AVPlayer.Status {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVPlayer.Status).self)
        }
        
    }
    
    
     var isMuted: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
     var currentItem: AVPlayerItem? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVPlayerItem?).self)
        }
        
    }
    
    
     var currentDuration: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
     var currentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
     var optimisticCurrentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
     var isSeeking: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    

    

    
     func play()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func pause()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any  {
        return DefaultValueRegistry.defaultValue(for: (Any).self)
    }
    
     func removeTimeObserver(_ observer: Any)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func removeObserver(_ observer: NSObject, forKeyPath keyPath: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func replaceCurrentItem(with item: AVPlayerItem?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Domain/Services/AnnotationServicing.swift at 2020-07-28 10:41:30 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import Foundation


 class MockAnnotationServicing: AnnotationServicing, Cuckoo.ProtocolMock {
    
     typealias MocksType = AnnotationServicing
    
     typealias Stubbing = __StubbingProxy_AnnotationServicing
     typealias Verification = __VerificationProxy_AnnotationServicing

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnnotationServicing?

     func enableDefaultImplementation(_ stub: AnnotationServicing) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func evaluate(_ input: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())  {
        
    return cuckoo_manager.call("evaluate(_: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())",
            parameters: (input, callback),
            escapingParameters: (input, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.evaluate(input, callback: callback))
        
    }
    

	 struct __StubbingProxy_AnnotationServicing: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func evaluate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ input: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(AnnotationService.EvaluationInput, (AnnotationService.EvaluationOutput) -> ())> where M1.MatchedType == AnnotationService.EvaluationInput, M2.MatchedType == (AnnotationService.EvaluationOutput) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(AnnotationService.EvaluationInput, (AnnotationService.EvaluationOutput) -> ())>] = [wrap(matchable: input) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAnnotationServicing.self, method: "evaluate(_: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_AnnotationServicing: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func evaluate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ input: M1, callback: M2) -> Cuckoo.__DoNotUse<(AnnotationService.EvaluationInput, (AnnotationService.EvaluationOutput) -> ()), Void> where M1.MatchedType == AnnotationService.EvaluationInput, M2.MatchedType == (AnnotationService.EvaluationOutput) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(AnnotationService.EvaluationInput, (AnnotationService.EvaluationOutput) -> ())>] = [wrap(matchable: input) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("evaluate(_: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class AnnotationServicingStub: AnnotationServicing {
    

    

    
     func evaluate(_ input: AnnotationService.EvaluationInput, callback: @escaping (AnnotationService.EvaluationOutput) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

