// MARK: - Mocks generated from file: Sources/App/Utils/MLSAVPlayerProtocol.swift at 2020-09-14 16:06:26 +0000

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
    
    
    
     var currentDuration: Double {
        get {
            return cuckoo_manager.getter("currentDuration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDuration)
        }
        
    }
    
    
    
     var currentDurationAsCMTime: CMTime? {
        get {
            return cuckoo_manager.getter("currentDurationAsCMTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDurationAsCMTime)
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
    
    
    
     func replaceCurrentItem(with assetUrl: URL?, headers: [String: String], callback: @escaping (Bool) -> ())  {
        
    return cuckoo_manager.call("replaceCurrentItem(with: URL?, headers: [String: String], callback: @escaping (Bool) -> ())",
            parameters: (assetUrl, headers, callback),
            escapingParameters: (assetUrl, headers, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.replaceCurrentItem(with: assetUrl, headers: headers, callback: callback))
        
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
	    
	    
	    var currentDuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration")
	    }
	    
	    
	    var currentDurationAsCMTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSAVPlayerProtocol, CMTime?> {
	        return .init(manager: cuckoo_manager, name: "currentDurationAsCMTime")
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
	    
	    func replaceCurrentItem<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with assetUrl: M1, headers: M2, callback: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(URL?, [String: String], (Bool) -> ())> where M1.OptionalMatchedType == URL, M2.MatchedType == [String: String], M3.MatchedType == (Bool) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL?, [String: String], (Bool) -> ())>] = [wrap(matchable: assetUrl) { $0.0 }, wrap(matchable: headers) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSAVPlayerProtocol.self, method: "replaceCurrentItem(with: URL?, headers: [String: String], callback: @escaping (Bool) -> ())", parameterMatchers: matchers))
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
	    
	    
	    var currentDuration: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentDurationAsCMTime: Cuckoo.VerifyReadOnlyProperty<CMTime?> {
	        return .init(manager: cuckoo_manager, name: "currentDurationAsCMTime", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    func replaceCurrentItem<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with assetUrl: M1, headers: M2, callback: M3) -> Cuckoo.__DoNotUse<(URL?, [String: String], (Bool) -> ()), Void> where M1.OptionalMatchedType == URL, M2.MatchedType == [String: String], M3.MatchedType == (Bool) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL?, [String: String], (Bool) -> ())>] = [wrap(matchable: assetUrl) { $0.0 }, wrap(matchable: headers) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("replaceCurrentItem(with: URL?, headers: [String: String], callback: @escaping (Bool) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
    
     var currentDuration: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
     var currentDurationAsCMTime: CMTime? {
        get {
            return DefaultValueRegistry.defaultValue(for: (CMTime?).self)
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
    
     func replaceCurrentItem(with assetUrl: URL?, headers: [String: String], callback: @escaping (Bool) -> ())   {
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


// MARK: - Mocks generated from file: Sources/App/View/VideoPlayer/VideoPlayerViewProtocol+iOS.swift at 2020-09-14 16:06:26 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import AVFoundation
import Foundation
import UIKit


 class MockVideoPlayerViewProtocol: VideoPlayerViewProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = VideoPlayerViewProtocol
    
     typealias Stubbing = __StubbingProxy_VideoPlayerViewProtocol
     typealias Verification = __VerificationProxy_VideoPlayerViewProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: VideoPlayerViewProtocol?

     func enableDefaultImplementation(_ stub: VideoPlayerViewProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var videoSlider: VideoProgressSlider {
        get {
            return cuckoo_manager.getter("videoSlider",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.videoSlider)
        }
        
    }
    
    
    
     var primaryColor: UIColor {
        get {
            return cuckoo_manager.getter("primaryColor",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.primaryColor)
        }
        
        set {
            cuckoo_manager.setter("primaryColor",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.primaryColor = newValue)
        }
        
    }
    
    
    
     var secondaryColor: UIColor {
        get {
            return cuckoo_manager.getter("secondaryColor",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.secondaryColor)
        }
        
        set {
            cuckoo_manager.setter("secondaryColor",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.secondaryColor = newValue)
        }
        
    }
    
    
    
     var controlViewHasAlpha: Bool {
        get {
            return cuckoo_manager.getter("controlViewHasAlpha",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.controlViewHasAlpha)
        }
        
    }
    
    
    
     var infoViewHasAlpha: Bool {
        get {
            return cuckoo_manager.getter("infoViewHasAlpha",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.infoViewHasAlpha)
        }
        
    }
    
    
    
     var infoTitleLabel: UILabel {
        get {
            return cuckoo_manager.getter("infoTitleLabel",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.infoTitleLabel)
        }
        
    }
    
    
    
     var infoDateLabel: UILabel {
        get {
            return cuckoo_manager.getter("infoDateLabel",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.infoDateLabel)
        }
        
    }
    
    
    
     var infoDescriptionLabel: UILabel {
        get {
            return cuckoo_manager.getter("infoDescriptionLabel",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.infoDescriptionLabel)
        }
        
    }
    
    
    
     var controlView: UIView {
        get {
            return cuckoo_manager.getter("controlView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.controlView)
        }
        
    }
    
    
    
     var playerLayer: AVPlayerLayer? {
        get {
            return cuckoo_manager.getter("playerLayer",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playerLayer)
        }
        
    }
    
    
    
     var topControlsStackView: UIStackView {
        get {
            return cuckoo_manager.getter("topControlsStackView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.topControlsStackView)
        }
        
    }
    
    
    
     var fullscreenButtonIsHidden: Bool {
        get {
            return cuckoo_manager.getter("fullscreenButtonIsHidden",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.fullscreenButtonIsHidden)
        }
        
        set {
            cuckoo_manager.setter("fullscreenButtonIsHidden",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.fullscreenButtonIsHidden = newValue)
        }
        
    }
    
    
    
     var tapGestureRecognizer: UITapGestureRecognizer {
        get {
            return cuckoo_manager.getter("tapGestureRecognizer",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.tapGestureRecognizer)
        }
        
    }
    

    

    
    
    
     func drawPlayer(with player: MLSAVPlayerProtocol)  {
        
    return cuckoo_manager.call("drawPlayer(with: MLSAVPlayerProtocol)",
            parameters: (player),
            escapingParameters: (player),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.drawPlayer(with: player))
        
    }
    
    
    
     func setOnPlayButtonTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnPlayButtonTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnPlayButtonTapped(action))
        
    }
    
    
    
     func setOnSkipBackButtonTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnSkipBackButtonTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnSkipBackButtonTapped(action))
        
    }
    
    
    
     func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnSkipForwardButtonTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnSkipForwardButtonTapped(action))
        
    }
    
    
    
     func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void)  {
        
    return cuckoo_manager.call("setOnTimeSliderSlide(_: @escaping (Double) -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnTimeSliderSlide(action))
        
    }
    
    
    
     func setOnTimeSliderRelease(_ action: @escaping (Double) -> Void)  {
        
    return cuckoo_manager.call("setOnTimeSliderRelease(_: @escaping (Double) -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnTimeSliderRelease(action))
        
    }
    
    
    
     func setControlViewVisibility(visible: Bool, animated: Bool)  {
        
    return cuckoo_manager.call("setControlViewVisibility(visible: Bool, animated: Bool)",
            parameters: (visible, animated),
            escapingParameters: (visible, animated),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setControlViewVisibility(visible: visible, animated: animated))
        
    }
    
    
    
     func setInfoViewVisibility(visible: Bool, animated: Bool)  {
        
    return cuckoo_manager.call("setInfoViewVisibility(visible: Bool, animated: Bool)",
            parameters: (visible, animated),
            escapingParameters: (visible, animated),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setInfoViewVisibility(visible: visible, animated: animated))
        
    }
    
    
    
     func setPlayButtonTo(state: VideoPlayer.PlayButtonState)  {
        
    return cuckoo_manager.call("setPlayButtonTo(state: VideoPlayer.PlayButtonState)",
            parameters: (state),
            escapingParameters: (state),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPlayButtonTo(state: state))
        
    }
    
    
    
     func setLiveButtonTo(state: VideoPlayer.LiveState)  {
        
    return cuckoo_manager.call("setLiveButtonTo(state: VideoPlayer.LiveState)",
            parameters: (state),
            escapingParameters: (state),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setLiveButtonTo(state: state))
        
    }
    
    
    
     func setNumberOfViewersTo(amount: String?)  {
        
    return cuckoo_manager.call("setNumberOfViewersTo(amount: String?)",
            parameters: (amount),
            escapingParameters: (amount),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setNumberOfViewersTo(amount: amount))
        
    }
    
    
    
     func setOnControlViewTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnControlViewTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnControlViewTapped(action))
        
    }
    
    
    
     func setOnLiveButtonTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnLiveButtonTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnLiveButtonTapped(action))
        
    }
    
    
    
     func setOnFullscreenButtonTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnFullscreenButtonTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnFullscreenButtonTapped(action))
        
    }
    
    
    
     func setOnInfoButtonTapped(_ action: @escaping () -> Void)  {
        
    return cuckoo_manager.call("setOnInfoButtonTapped(_: @escaping () -> Void)",
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setOnInfoButtonTapped(action))
        
    }
    
    
    
     func setFullscreenButtonTo(fullscreen: Bool)  {
        
    return cuckoo_manager.call("setFullscreenButtonTo(fullscreen: Bool)",
            parameters: (fullscreen),
            escapingParameters: (fullscreen),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setFullscreenButtonTo(fullscreen: fullscreen))
        
    }
    
    
    
     func setBufferIcon(hidden: Bool)  {
        
    return cuckoo_manager.call("setBufferIcon(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setBufferIcon(hidden: hidden))
        
    }
    
    
    
     func setInfoButton(hidden: Bool)  {
        
    return cuckoo_manager.call("setInfoButton(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setInfoButton(hidden: hidden))
        
    }
    
    
    
     func setSkipButtons(hidden: Bool)  {
        
    return cuckoo_manager.call("setSkipButtons(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setSkipButtons(hidden: hidden))
        
    }
    
    
    
     func setTimeIndicatorLabel(elapsedText: String?, totalText: String?)  {
        
    return cuckoo_manager.call("setTimeIndicatorLabel(elapsedText: String?, totalText: String?)",
            parameters: (elapsedText, totalText),
            escapingParameters: (elapsedText, totalText),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setTimeIndicatorLabel(elapsedText: elapsedText, totalText: totalText))
        
    }
    
    
    
     func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])  {
        
    return cuckoo_manager.call("setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])",
            parameters: (actions),
            escapingParameters: (actions),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setTimelineMarkers(with: actions))
        
    }
    
    
    
     func placeOverlay(imageView: UIView, size: AnnotationActionShowOverlay.Size, position: AnnotationActionShowOverlay.Position, animateType: OverlayAnimateinType, animateDuration: Double) -> UIView {
        
    return cuckoo_manager.call("placeOverlay(imageView: UIView, size: AnnotationActionShowOverlay.Size, position: AnnotationActionShowOverlay.Position, animateType: OverlayAnimateinType, animateDuration: Double) -> UIView",
            parameters: (imageView, size, position, animateType, animateDuration),
            escapingParameters: (imageView, size, position, animateType, animateDuration),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.placeOverlay(imageView: imageView, size: size, position: position, animateType: animateType, animateDuration: animateDuration))
        
    }
    
    
    
     func replaceOverlay(containerView: UIView, imageView: UIView)  {
        
    return cuckoo_manager.call("replaceOverlay(containerView: UIView, imageView: UIView)",
            parameters: (containerView, imageView),
            escapingParameters: (containerView, imageView),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.replaceOverlay(containerView: containerView, imageView: imageView))
        
    }
    
    
    
     func removeOverlay(containerView: UIView, animateType: OverlayAnimateoutType, animateDuration: Double, completion: @escaping (() -> Void))  {
        
    return cuckoo_manager.call("removeOverlay(containerView: UIView, animateType: OverlayAnimateoutType, animateDuration: Double, completion: @escaping (() -> Void))",
            parameters: (containerView, animateType, animateDuration, completion),
            escapingParameters: (containerView, animateType, animateDuration, completion),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeOverlay(containerView: containerView, animateType: animateType, animateDuration: animateDuration, completion: completion))
        
    }
    

	 struct __StubbingProxy_VideoPlayerViewProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var videoSlider: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, VideoProgressSlider> {
	        return .init(manager: cuckoo_manager, name: "videoSlider")
	    }
	    
	    
	    var primaryColor: Cuckoo.ProtocolToBeStubbedProperty<MockVideoPlayerViewProtocol, UIColor> {
	        return .init(manager: cuckoo_manager, name: "primaryColor")
	    }
	    
	    
	    var secondaryColor: Cuckoo.ProtocolToBeStubbedProperty<MockVideoPlayerViewProtocol, UIColor> {
	        return .init(manager: cuckoo_manager, name: "secondaryColor")
	    }
	    
	    
	    var controlViewHasAlpha: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "controlViewHasAlpha")
	    }
	    
	    
	    var infoViewHasAlpha: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "infoViewHasAlpha")
	    }
	    
	    
	    var infoTitleLabel: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UILabel> {
	        return .init(manager: cuckoo_manager, name: "infoTitleLabel")
	    }
	    
	    
	    var infoDateLabel: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UILabel> {
	        return .init(manager: cuckoo_manager, name: "infoDateLabel")
	    }
	    
	    
	    var infoDescriptionLabel: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UILabel> {
	        return .init(manager: cuckoo_manager, name: "infoDescriptionLabel")
	    }
	    
	    
	    var controlView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UIView> {
	        return .init(manager: cuckoo_manager, name: "controlView")
	    }
	    
	    
	    var playerLayer: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, AVPlayerLayer?> {
	        return .init(manager: cuckoo_manager, name: "playerLayer")
	    }
	    
	    
	    var topControlsStackView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UIStackView> {
	        return .init(manager: cuckoo_manager, name: "topControlsStackView")
	    }
	    
	    
	    var fullscreenButtonIsHidden: Cuckoo.ProtocolToBeStubbedProperty<MockVideoPlayerViewProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "fullscreenButtonIsHidden")
	    }
	    
	    
	    var tapGestureRecognizer: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UITapGestureRecognizer> {
	        return .init(manager: cuckoo_manager, name: "tapGestureRecognizer")
	    }
	    
	    
	    func drawPlayer<M1: Cuckoo.Matchable>(with player: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MLSAVPlayerProtocol)> where M1.MatchedType == MLSAVPlayerProtocol {
	        let matchers: [Cuckoo.ParameterMatcher<(MLSAVPlayerProtocol)>] = [wrap(matchable: player) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "drawPlayer(with: MLSAVPlayerProtocol)", parameterMatchers: matchers))
	    }
	    
	    func setOnPlayButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnPlayButtonTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnSkipBackButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnSkipBackButtonTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnSkipForwardButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnSkipForwardButtonTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnTimeSliderSlide<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<((Double) -> Void)> where M1.MatchedType == (Double) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<((Double) -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnTimeSliderSlide(_: @escaping (Double) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnTimeSliderRelease<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<((Double) -> Void)> where M1.MatchedType == (Double) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<((Double) -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnTimeSliderRelease(_: @escaping (Double) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setControlViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, animated: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, Bool)> where M1.MatchedType == Bool, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Bool)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: animated) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setControlViewVisibility(visible: Bool, animated: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setInfoViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, animated: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, Bool)> where M1.MatchedType == Bool, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Bool)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: animated) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setInfoViewVisibility(visible: Bool, animated: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setPlayButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoPlayer.PlayButtonState)> where M1.MatchedType == VideoPlayer.PlayButtonState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayer.PlayButtonState)>] = [wrap(matchable: state) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setPlayButtonTo(state: VideoPlayer.PlayButtonState)", parameterMatchers: matchers))
	    }
	    
	    func setLiveButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoPlayer.LiveState)> where M1.MatchedType == VideoPlayer.LiveState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayer.LiveState)>] = [wrap(matchable: state) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setLiveButtonTo(state: VideoPlayer.LiveState)", parameterMatchers: matchers))
	    }
	    
	    func setNumberOfViewersTo<M1: Cuckoo.OptionalMatchable>(amount: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String?)> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: amount) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setNumberOfViewersTo(amount: String?)", parameterMatchers: matchers))
	    }
	    
	    func setOnControlViewTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnControlViewTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnLiveButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnLiveButtonTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnFullscreenButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnFullscreenButtonTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setOnInfoButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setOnInfoButtonTapped(_: @escaping () -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setFullscreenButtonTo<M1: Cuckoo.Matchable>(fullscreen: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: fullscreen) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setFullscreenButtonTo(fullscreen: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setBufferIcon<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setBufferIcon(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setInfoButton<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setInfoButton(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setSkipButtons<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setSkipButtons(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setTimeIndicatorLabel<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(elapsedText: M1, totalText: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?)>] = [wrap(matchable: elapsedText) { $0.0 }, wrap(matchable: totalText) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setTimeIndicatorLabel(elapsedText: String?, totalText: String?)", parameterMatchers: matchers))
	    }
	    
	    func setTimelineMarkers<M1: Cuckoo.Matchable>(with actions: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([MLSUI.ShowTimelineMarkerAction])> where M1.MatchedType == [MLSUI.ShowTimelineMarkerAction] {
	        let matchers: [Cuckoo.ParameterMatcher<([MLSUI.ShowTimelineMarkerAction])>] = [wrap(matchable: actions) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])", parameterMatchers: matchers))
	    }
	    
	    func placeOverlay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(imageView: M1, size: M2, position: M3, animateType: M4, animateDuration: M5) -> Cuckoo.ProtocolStubFunction<(UIView, AnnotationActionShowOverlay.Size, AnnotationActionShowOverlay.Position, OverlayAnimateinType, Double), UIView> where M1.MatchedType == UIView, M2.MatchedType == AnnotationActionShowOverlay.Size, M3.MatchedType == AnnotationActionShowOverlay.Position, M4.MatchedType == OverlayAnimateinType, M5.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(UIView, AnnotationActionShowOverlay.Size, AnnotationActionShowOverlay.Position, OverlayAnimateinType, Double)>] = [wrap(matchable: imageView) { $0.0 }, wrap(matchable: size) { $0.1 }, wrap(matchable: position) { $0.2 }, wrap(matchable: animateType) { $0.3 }, wrap(matchable: animateDuration) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "placeOverlay(imageView: UIView, size: AnnotationActionShowOverlay.Size, position: AnnotationActionShowOverlay.Position, animateType: OverlayAnimateinType, animateDuration: Double) -> UIView", parameterMatchers: matchers))
	    }
	    
	    func replaceOverlay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(containerView: M1, imageView: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(UIView, UIView)> where M1.MatchedType == UIView, M2.MatchedType == UIView {
	        let matchers: [Cuckoo.ParameterMatcher<(UIView, UIView)>] = [wrap(matchable: containerView) { $0.0 }, wrap(matchable: imageView) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "replaceOverlay(containerView: UIView, imageView: UIView)", parameterMatchers: matchers))
	    }
	    
	    func removeOverlay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(containerView: M1, animateType: M2, animateDuration: M3, completion: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(UIView, OverlayAnimateoutType, Double, (() -> Void))> where M1.MatchedType == UIView, M2.MatchedType == OverlayAnimateoutType, M3.MatchedType == Double, M4.MatchedType == (() -> Void) {
	        let matchers: [Cuckoo.ParameterMatcher<(UIView, OverlayAnimateoutType, Double, (() -> Void))>] = [wrap(matchable: containerView) { $0.0 }, wrap(matchable: animateType) { $0.1 }, wrap(matchable: animateDuration) { $0.2 }, wrap(matchable: completion) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "removeOverlay(containerView: UIView, animateType: OverlayAnimateoutType, animateDuration: Double, completion: @escaping (() -> Void))", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_VideoPlayerViewProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var videoSlider: Cuckoo.VerifyReadOnlyProperty<VideoProgressSlider> {
	        return .init(manager: cuckoo_manager, name: "videoSlider", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var primaryColor: Cuckoo.VerifyProperty<UIColor> {
	        return .init(manager: cuckoo_manager, name: "primaryColor", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var secondaryColor: Cuckoo.VerifyProperty<UIColor> {
	        return .init(manager: cuckoo_manager, name: "secondaryColor", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var controlViewHasAlpha: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "controlViewHasAlpha", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var infoViewHasAlpha: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "infoViewHasAlpha", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var infoTitleLabel: Cuckoo.VerifyReadOnlyProperty<UILabel> {
	        return .init(manager: cuckoo_manager, name: "infoTitleLabel", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var infoDateLabel: Cuckoo.VerifyReadOnlyProperty<UILabel> {
	        return .init(manager: cuckoo_manager, name: "infoDateLabel", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var infoDescriptionLabel: Cuckoo.VerifyReadOnlyProperty<UILabel> {
	        return .init(manager: cuckoo_manager, name: "infoDescriptionLabel", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var controlView: Cuckoo.VerifyReadOnlyProperty<UIView> {
	        return .init(manager: cuckoo_manager, name: "controlView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var playerLayer: Cuckoo.VerifyReadOnlyProperty<AVPlayerLayer?> {
	        return .init(manager: cuckoo_manager, name: "playerLayer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var topControlsStackView: Cuckoo.VerifyReadOnlyProperty<UIStackView> {
	        return .init(manager: cuckoo_manager, name: "topControlsStackView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var fullscreenButtonIsHidden: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "fullscreenButtonIsHidden", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var tapGestureRecognizer: Cuckoo.VerifyReadOnlyProperty<UITapGestureRecognizer> {
	        return .init(manager: cuckoo_manager, name: "tapGestureRecognizer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func drawPlayer<M1: Cuckoo.Matchable>(with player: M1) -> Cuckoo.__DoNotUse<(MLSAVPlayerProtocol), Void> where M1.MatchedType == MLSAVPlayerProtocol {
	        let matchers: [Cuckoo.ParameterMatcher<(MLSAVPlayerProtocol)>] = [wrap(matchable: player) { $0 }]
	        return cuckoo_manager.verify("drawPlayer(with: MLSAVPlayerProtocol)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnPlayButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnPlayButtonTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnSkipBackButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnSkipBackButtonTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnSkipForwardButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnSkipForwardButtonTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnTimeSliderSlide<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<((Double) -> Void), Void> where M1.MatchedType == (Double) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<((Double) -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnTimeSliderSlide(_: @escaping (Double) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnTimeSliderRelease<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<((Double) -> Void), Void> where M1.MatchedType == (Double) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<((Double) -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnTimeSliderRelease(_: @escaping (Double) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setControlViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, animated: M2) -> Cuckoo.__DoNotUse<(Bool, Bool), Void> where M1.MatchedType == Bool, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Bool)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: animated) { $0.1 }]
	        return cuckoo_manager.verify("setControlViewVisibility(visible: Bool, animated: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setInfoViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, animated: M2) -> Cuckoo.__DoNotUse<(Bool, Bool), Void> where M1.MatchedType == Bool, M2.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Bool)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: animated) { $0.1 }]
	        return cuckoo_manager.verify("setInfoViewVisibility(visible: Bool, animated: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setPlayButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.__DoNotUse<(VideoPlayer.PlayButtonState), Void> where M1.MatchedType == VideoPlayer.PlayButtonState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayer.PlayButtonState)>] = [wrap(matchable: state) { $0 }]
	        return cuckoo_manager.verify("setPlayButtonTo(state: VideoPlayer.PlayButtonState)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setLiveButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.__DoNotUse<(VideoPlayer.LiveState), Void> where M1.MatchedType == VideoPlayer.LiveState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayer.LiveState)>] = [wrap(matchable: state) { $0 }]
	        return cuckoo_manager.verify("setLiveButtonTo(state: VideoPlayer.LiveState)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setNumberOfViewersTo<M1: Cuckoo.OptionalMatchable>(amount: M1) -> Cuckoo.__DoNotUse<(String?), Void> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: amount) { $0 }]
	        return cuckoo_manager.verify("setNumberOfViewersTo(amount: String?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnControlViewTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnControlViewTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnLiveButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnLiveButtonTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnFullscreenButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnFullscreenButtonTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setOnInfoButtonTapped<M1: Cuckoo.Matchable>(_ action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
	        return cuckoo_manager.verify("setOnInfoButtonTapped(_: @escaping () -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setFullscreenButtonTo<M1: Cuckoo.Matchable>(fullscreen: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: fullscreen) { $0 }]
	        return cuckoo_manager.verify("setFullscreenButtonTo(fullscreen: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setBufferIcon<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setBufferIcon(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setInfoButton<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setInfoButton(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setSkipButtons<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setSkipButtons(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setTimeIndicatorLabel<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(elapsedText: M1, totalText: M2) -> Cuckoo.__DoNotUse<(String?, String?), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?)>] = [wrap(matchable: elapsedText) { $0.0 }, wrap(matchable: totalText) { $0.1 }]
	        return cuckoo_manager.verify("setTimeIndicatorLabel(elapsedText: String?, totalText: String?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setTimelineMarkers<M1: Cuckoo.Matchable>(with actions: M1) -> Cuckoo.__DoNotUse<([MLSUI.ShowTimelineMarkerAction]), Void> where M1.MatchedType == [MLSUI.ShowTimelineMarkerAction] {
	        let matchers: [Cuckoo.ParameterMatcher<([MLSUI.ShowTimelineMarkerAction])>] = [wrap(matchable: actions) { $0 }]
	        return cuckoo_manager.verify("setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func placeOverlay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(imageView: M1, size: M2, position: M3, animateType: M4, animateDuration: M5) -> Cuckoo.__DoNotUse<(UIView, AnnotationActionShowOverlay.Size, AnnotationActionShowOverlay.Position, OverlayAnimateinType, Double), UIView> where M1.MatchedType == UIView, M2.MatchedType == AnnotationActionShowOverlay.Size, M3.MatchedType == AnnotationActionShowOverlay.Position, M4.MatchedType == OverlayAnimateinType, M5.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(UIView, AnnotationActionShowOverlay.Size, AnnotationActionShowOverlay.Position, OverlayAnimateinType, Double)>] = [wrap(matchable: imageView) { $0.0 }, wrap(matchable: size) { $0.1 }, wrap(matchable: position) { $0.2 }, wrap(matchable: animateType) { $0.3 }, wrap(matchable: animateDuration) { $0.4 }]
	        return cuckoo_manager.verify("placeOverlay(imageView: UIView, size: AnnotationActionShowOverlay.Size, position: AnnotationActionShowOverlay.Position, animateType: OverlayAnimateinType, animateDuration: Double) -> UIView", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func replaceOverlay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(containerView: M1, imageView: M2) -> Cuckoo.__DoNotUse<(UIView, UIView), Void> where M1.MatchedType == UIView, M2.MatchedType == UIView {
	        let matchers: [Cuckoo.ParameterMatcher<(UIView, UIView)>] = [wrap(matchable: containerView) { $0.0 }, wrap(matchable: imageView) { $0.1 }]
	        return cuckoo_manager.verify("replaceOverlay(containerView: UIView, imageView: UIView)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeOverlay<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(containerView: M1, animateType: M2, animateDuration: M3, completion: M4) -> Cuckoo.__DoNotUse<(UIView, OverlayAnimateoutType, Double, (() -> Void)), Void> where M1.MatchedType == UIView, M2.MatchedType == OverlayAnimateoutType, M3.MatchedType == Double, M4.MatchedType == (() -> Void) {
	        let matchers: [Cuckoo.ParameterMatcher<(UIView, OverlayAnimateoutType, Double, (() -> Void))>] = [wrap(matchable: containerView) { $0.0 }, wrap(matchable: animateType) { $0.1 }, wrap(matchable: animateDuration) { $0.2 }, wrap(matchable: completion) { $0.3 }]
	        return cuckoo_manager.verify("removeOverlay(containerView: UIView, animateType: OverlayAnimateoutType, animateDuration: Double, completion: @escaping (() -> Void))", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class VideoPlayerViewProtocolStub: VideoPlayerViewProtocol {
    
    
     var videoSlider: VideoProgressSlider {
        get {
            return DefaultValueRegistry.defaultValue(for: (VideoProgressSlider).self)
        }
        
    }
    
    
     var primaryColor: UIColor {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIColor).self)
        }
        
        set { }
        
    }
    
    
     var secondaryColor: UIColor {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIColor).self)
        }
        
        set { }
        
    }
    
    
     var controlViewHasAlpha: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
     var infoViewHasAlpha: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
     var infoTitleLabel: UILabel {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel).self)
        }
        
    }
    
    
     var infoDateLabel: UILabel {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel).self)
        }
        
    }
    
    
     var infoDescriptionLabel: UILabel {
        get {
            return DefaultValueRegistry.defaultValue(for: (UILabel).self)
        }
        
    }
    
    
     var controlView: UIView {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIView).self)
        }
        
    }
    
    
     var playerLayer: AVPlayerLayer? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVPlayerLayer?).self)
        }
        
    }
    
    
     var topControlsStackView: UIStackView {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIStackView).self)
        }
        
    }
    
    
     var fullscreenButtonIsHidden: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
     var tapGestureRecognizer: UITapGestureRecognizer {
        get {
            return DefaultValueRegistry.defaultValue(for: (UITapGestureRecognizer).self)
        }
        
    }
    

    

    
     func drawPlayer(with player: MLSAVPlayerProtocol)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnPlayButtonTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnSkipBackButtonTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnSkipForwardButtonTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnTimeSliderSlide(_ action: @escaping (Double) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnTimeSliderRelease(_ action: @escaping (Double) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setControlViewVisibility(visible: Bool, animated: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setInfoViewVisibility(visible: Bool, animated: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setPlayButtonTo(state: VideoPlayer.PlayButtonState)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setLiveButtonTo(state: VideoPlayer.LiveState)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setNumberOfViewersTo(amount: String?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnControlViewTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnLiveButtonTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnFullscreenButtonTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setOnInfoButtonTapped(_ action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setFullscreenButtonTo(fullscreen: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setBufferIcon(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setInfoButton(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setSkipButtons(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setTimeIndicatorLabel(elapsedText: String?, totalText: String?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func placeOverlay(imageView: UIView, size: AnnotationActionShowOverlay.Size, position: AnnotationActionShowOverlay.Position, animateType: OverlayAnimateinType, animateDuration: Double) -> UIView  {
        return DefaultValueRegistry.defaultValue(for: (UIView).self)
    }
    
     func replaceOverlay(containerView: UIView, imageView: UIView)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func removeOverlay(containerView: UIView, animateType: OverlayAnimateoutType, animateDuration: Double, completion: @escaping (() -> Void))   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Domain/Repositories/ArbitraryDataRepository.swift at 2020-09-14 16:06:26 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import Foundation


 class MockArbitraryDataRepository: ArbitraryDataRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = ArbitraryDataRepository
    
     typealias Stubbing = __StubbingProxy_ArbitraryDataRepository
     typealias Verification = __VerificationProxy_ArbitraryDataRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ArbitraryDataRepository?

     func enableDefaultImplementation(_ stub: ArbitraryDataRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchDataAsString(byURL: URL, callback: @escaping (String?, Error?) -> ())",
            parameters: (url, callback),
            escapingParameters: (url, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchDataAsString(byURL: url, callback: callback))
        
    }
    

	 struct __StubbingProxy_ArbitraryDataRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchDataAsString<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URL, (String?, Error?) -> ())> where M1.MatchedType == URL, M2.MatchedType == (String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (String?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockArbitraryDataRepository.self, method: "fetchDataAsString(byURL: URL, callback: @escaping (String?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ArbitraryDataRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchDataAsString<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.__DoNotUse<(URL, (String?, Error?) -> ()), Void> where M1.MatchedType == URL, M2.MatchedType == (String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (String?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchDataAsString(byURL: URL, callback: @escaping (String?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ArbitraryDataRepositoryStub: ArbitraryDataRepository {
    

    

    
     func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Domain/Repositories/EventRepository.swift at 2020-09-14 16:06:26 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import Foundation


 class MockEventRepository: EventRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = EventRepository
    
     typealias Stubbing = __StubbingProxy_EventRepository
     typealias Verification = __VerificationProxy_EventRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: EventRepository?

     func enableDefaultImplementation(_ stub: EventRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchEvent(byId: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())",
            parameters: (id, updateId, callback),
            escapingParameters: (id, updateId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchEvent(byId: id, updateId: updateId, callback: callback))
        
    }
    
    
    
     func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())",
            parameters: (pageSize, pageToken, status, orderBy, callback),
            escapingParameters: (pageSize, pageToken, status, orderBy, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchEvents(pageSize: pageSize, pageToken: pageToken, status: status, orderBy: orderBy, callback: callback))
        
    }
    
    
    
     func startEventUpdates(for id: String, pseudoUserId: String, callback: @escaping (EventRepositoryEventUpdate) -> ())  {
        
    return cuckoo_manager.call("startEventUpdates(for: String, pseudoUserId: String, callback: @escaping (EventRepositoryEventUpdate) -> ())",
            parameters: (id, pseudoUserId, callback),
            escapingParameters: (id, pseudoUserId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startEventUpdates(for: id, pseudoUserId: pseudoUserId, callback: callback))
        
    }
    
    
    
     func stopEventUpdates(for id: String)  {
        
    return cuckoo_manager.call("stopEventUpdates(for: String)",
            parameters: (id),
            escapingParameters: (id),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopEventUpdates(for: id))
        
    }
    

	 struct __StubbingProxy_EventRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchEvent<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(byId id: M1, updateId: M2, callback: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String?, (Event?, Error?) -> ())> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == (Event?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, (Event?, Error?) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: updateId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventRepository.self, method: "fetchEvent(byId: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchEvents<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable>(pageSize: M1, pageToken: M2, status: M3, orderBy: M4, callback: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(Int?, String?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, String?, String?, Error?) -> ())> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.OptionalMatchedType == [ParamEventStatus], M4.OptionalMatchedType == ParamEventOrder, M5.MatchedType == ([Event]?, String?, String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, String?, String?, Error?) -> ())>] = [wrap(matchable: pageSize) { $0.0 }, wrap(matchable: pageToken) { $0.1 }, wrap(matchable: status) { $0.2 }, wrap(matchable: orderBy) { $0.3 }, wrap(matchable: callback) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventRepository.self, method: "fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func startEventUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(for id: M1, pseudoUserId: M2, callback: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String, (EventRepositoryEventUpdate) -> ())> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == (EventRepositoryEventUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String, (EventRepositoryEventUpdate) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: pseudoUserId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventRepository.self, method: "startEventUpdates(for: String, pseudoUserId: String, callback: @escaping (EventRepositoryEventUpdate) -> ())", parameterMatchers: matchers))
	    }
	    
	    func stopEventUpdates<M1: Cuckoo.Matchable>(for id: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockEventRepository.self, method: "stopEventUpdates(for: String)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_EventRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchEvent<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(byId id: M1, updateId: M2, callback: M3) -> Cuckoo.__DoNotUse<(String, String?, (Event?, Error?) -> ()), Void> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == (Event?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, (Event?, Error?) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: updateId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("fetchEvent(byId: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchEvents<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable>(pageSize: M1, pageToken: M2, status: M3, orderBy: M4, callback: M5) -> Cuckoo.__DoNotUse<(Int?, String?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, String?, String?, Error?) -> ()), Void> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.OptionalMatchedType == [ParamEventStatus], M4.OptionalMatchedType == ParamEventOrder, M5.MatchedType == ([Event]?, String?, String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, String?, String?, Error?) -> ())>] = [wrap(matchable: pageSize) { $0.0 }, wrap(matchable: pageToken) { $0.1 }, wrap(matchable: status) { $0.2 }, wrap(matchable: orderBy) { $0.3 }, wrap(matchable: callback) { $0.4 }]
	        return cuckoo_manager.verify("fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func startEventUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(for id: M1, pseudoUserId: M2, callback: M3) -> Cuckoo.__DoNotUse<(String, String, (EventRepositoryEventUpdate) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == (EventRepositoryEventUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String, (EventRepositoryEventUpdate) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: pseudoUserId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("startEventUpdates(for: String, pseudoUserId: String, callback: @escaping (EventRepositoryEventUpdate) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopEventUpdates<M1: Cuckoo.Matchable>(for id: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
	        return cuckoo_manager.verify("stopEventUpdates(for: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class EventRepositoryStub: EventRepository {
    

    

    
     func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func startEventUpdates(for id: String, pseudoUserId: String, callback: @escaping (EventRepositoryEventUpdate) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func stopEventUpdates(for id: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Domain/Repositories/PlayerConfigRepository.swift at 2020-09-14 16:06:26 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import Foundation


 class MockPlayerConfigRepository: PlayerConfigRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = PlayerConfigRepository
    
     typealias Stubbing = __StubbingProxy_PlayerConfigRepository
     typealias Verification = __VerificationProxy_PlayerConfigRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PlayerConfigRepository?

     func enableDefaultImplementation(_ stub: PlayerConfigRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())",
            parameters: (callback),
            escapingParameters: (callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchPlayerConfig(callback: callback))
        
    }
    

	 struct __StubbingProxy_PlayerConfigRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchPlayerConfig<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnFunction<((PlayerConfig?, Error?) -> ())> where M1.MatchedType == (PlayerConfig?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((PlayerConfig?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPlayerConfigRepository.self, method: "fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PlayerConfigRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchPlayerConfig<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.__DoNotUse<((PlayerConfig?, Error?) -> ()), Void> where M1.MatchedType == (PlayerConfig?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((PlayerConfig?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return cuckoo_manager.verify("fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PlayerConfigRepositoryStub: PlayerConfigRepository {
    

    

    
     func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Domain/Repositories/TimelineRepository.swift at 2020-09-14 16:06:26 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import Foundation


 class MockTimelineRepository: TimelineRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = TimelineRepository
    
     typealias Stubbing = __StubbingProxy_TimelineRepository
     typealias Verification = __VerificationProxy_TimelineRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: TimelineRepository?

     func enableDefaultImplementation(_ stub: TimelineRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchAnnotationActions(byTimelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())",
            parameters: (timelineId, callback),
            escapingParameters: (timelineId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchAnnotationActions(byTimelineId: timelineId, callback: callback))
        
    }
    
    
    
     func startTimelineUpdates(for timelineId: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ())  {
        
    return cuckoo_manager.call("startTimelineUpdates(for: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ())",
            parameters: (timelineId, callback),
            escapingParameters: (timelineId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startTimelineUpdates(for: timelineId, callback: callback))
        
    }
    
    
    
     func stopTimelineUpdates(for timelineId: String)  {
        
    return cuckoo_manager.call("stopTimelineUpdates(for: String)",
            parameters: (timelineId),
            escapingParameters: (timelineId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopTimelineUpdates(for: timelineId))
        
    }
    

	 struct __StubbingProxy_TimelineRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchAnnotationActions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byTimelineId timelineId: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, ([AnnotationAction]?, Error?) -> ())> where M1.MatchedType == String, M2.MatchedType == ([AnnotationAction]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, ([AnnotationAction]?, Error?) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTimelineRepository.self, method: "fetchAnnotationActions(byTimelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func startTimelineUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for timelineId: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, (TimelineRepositoryTimelineUpdate) -> ())> where M1.MatchedType == String, M2.MatchedType == (TimelineRepositoryTimelineUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (TimelineRepositoryTimelineUpdate) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTimelineRepository.self, method: "startTimelineUpdates(for: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ())", parameterMatchers: matchers))
	    }
	    
	    func stopTimelineUpdates<M1: Cuckoo.Matchable>(for timelineId: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: timelineId) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockTimelineRepository.self, method: "stopTimelineUpdates(for: String)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_TimelineRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchAnnotationActions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byTimelineId timelineId: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, ([AnnotationAction]?, Error?) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == ([AnnotationAction]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, ([AnnotationAction]?, Error?) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchAnnotationActions(byTimelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func startTimelineUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for timelineId: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, (TimelineRepositoryTimelineUpdate) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == (TimelineRepositoryTimelineUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (TimelineRepositoryTimelineUpdate) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("startTimelineUpdates(for: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopTimelineUpdates<M1: Cuckoo.Matchable>(for timelineId: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: timelineId) { $0 }]
	        return cuckoo_manager.verify("stopTimelineUpdates(for: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class TimelineRepositoryStub: TimelineRepository {
    

    

    
     func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func startTimelineUpdates(for timelineId: String, callback: @escaping (TimelineRepositoryTimelineUpdate) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func stopTimelineUpdates(for timelineId: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Domain/Services/AnnotationServicing.swift at 2020-09-14 16:06:26 +0000

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

