// MARK: - Mocks generated from file: Sources/Annotations/Shared/AnnotationIntegrationDelegate.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation
import MLSSDK


public class MockAnnotationIntegrationDelegate: AnnotationIntegrationDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AnnotationIntegrationDelegate
    
    public typealias Stubbing = __StubbingProxy_AnnotationIntegrationDelegate
    public typealias Verification = __VerificationProxy_AnnotationIntegrationDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnnotationIntegrationDelegate?

    public func enableDefaultImplementation(_ stub: AnnotationIntegrationDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var annotationIntegrationView: AnnotationIntegrationView {
        get {
            return cuckoo_manager.getter("annotationIntegrationView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.annotationIntegrationView)
        }
        
    }
    
    
    
    public var currentDuration: Double {
        get {
            return cuckoo_manager.getter("currentDuration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDuration)
        }
        
    }
    
    
    
    public var optimisticCurrentTime: Double {
        get {
            return cuckoo_manager.getter("optimisticCurrentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.optimisticCurrentTime)
        }
        
    }
    

    

    
    
    
    public func isCasting() -> Bool {
        
    return cuckoo_manager.call("isCasting() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isCasting())
        
    }
    

	public struct __StubbingProxy_AnnotationIntegrationDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var annotationIntegrationView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnnotationIntegrationDelegate, AnnotationIntegrationView> {
	        return .init(manager: cuckoo_manager, name: "annotationIntegrationView")
	    }
	    
	    
	    var currentDuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnnotationIntegrationDelegate, Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration")
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnnotationIntegrationDelegate, Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime")
	    }
	    
	    
	    func isCasting() -> Cuckoo.ProtocolStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAnnotationIntegrationDelegate.self, method: "isCasting() -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AnnotationIntegrationDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var annotationIntegrationView: Cuckoo.VerifyReadOnlyProperty<AnnotationIntegrationView> {
	        return .init(manager: cuckoo_manager, name: "annotationIntegrationView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentDuration: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.VerifyReadOnlyProperty<Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func isCasting() -> Cuckoo.__DoNotUse<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("isCasting() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AnnotationIntegrationDelegateStub: AnnotationIntegrationDelegate {
    
    
    public var annotationIntegrationView: AnnotationIntegrationView {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnnotationIntegrationView).self)
        }
        
    }
    
    
    public var currentDuration: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var optimisticCurrentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    

    

    
    public func isCasting() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Annotations/Shared/OverlayViewPlacement.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation
import MLSSDK
import UIKit

// MARK: - Mocks generated from file: Sources/Annotations/Shared/Services/AnnotationServicing.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation
import MLSSDK


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


// MARK: - Mocks generated from file: Sources/Annotations/Shared/Services/HLSInspectionServicing.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


 class MockHLSInspectionServicing: HLSInspectionServicing, Cuckoo.ProtocolMock {
    
     typealias MocksType = HLSInspectionServicing
    
     typealias Stubbing = __StubbingProxy_HLSInspectionServicing
     typealias Verification = __VerificationProxy_HLSInspectionServicing

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: HLSInspectionServicing?

     func enableDefaultImplementation(_ stub: HLSInspectionServicing) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?] {
        
    return cuckoo_manager.call("map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?]",
            parameters: (hlsPlaylist, absoluteTimes),
            escapingParameters: (hlsPlaylist, absoluteTimes),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.map(hlsPlaylist: hlsPlaylist, absoluteTimes: absoluteTimes))
        
    }
    

	 struct __StubbingProxy_HLSInspectionServicing: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func map<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(hlsPlaylist: M1, absoluteTimes: M2) -> Cuckoo.ProtocolStubFunction<(String?, [Int64]), [Int64: (videoOffset: Int64, inGap: Bool)?]> where M1.OptionalMatchedType == String, M2.MatchedType == [Int64] {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, [Int64])>] = [wrap(matchable: hlsPlaylist) { $0.0 }, wrap(matchable: absoluteTimes) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockHLSInspectionServicing.self, method: "map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?]", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_HLSInspectionServicing: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func map<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(hlsPlaylist: M1, absoluteTimes: M2) -> Cuckoo.__DoNotUse<(String?, [Int64]), [Int64: (videoOffset: Int64, inGap: Bool)?]> where M1.OptionalMatchedType == String, M2.MatchedType == [Int64] {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, [Int64])>] = [wrap(matchable: hlsPlaylist) { $0.0 }, wrap(matchable: absoluteTimes) { $0.1 }]
	        return cuckoo_manager.verify("map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class HLSInspectionServicingStub: HLSInspectionServicing {
    

    

    
     func map(hlsPlaylist: String?, absoluteTimes: [Int64]) -> [Int64: (videoOffset: Int64, inGap: Bool)?]  {
        return DefaultValueRegistry.defaultValue(for: ([Int64: (videoOffset: Int64, inGap: Bool)?]).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/App/Core/AnnotationIntegration.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation
import UIKit


public class MockAnnotationIntegration: AnnotationIntegration, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AnnotationIntegration
    
    public typealias Stubbing = __StubbingProxy_AnnotationIntegration
    public typealias Verification = __VerificationProxy_AnnotationIntegration

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnnotationIntegration?

    public func enableDefaultImplementation(_ stub: AnnotationIntegration) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var timelineId: String? {
        get {
            return cuckoo_manager.getter("timelineId",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timelineId)
        }
        
        set {
            cuckoo_manager.setter("timelineId",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timelineId = newValue)
        }
        
    }
    
    
    
    public var localAnnotationActions: [AnnotationAction] {
        get {
            return cuckoo_manager.getter("localAnnotationActions",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.localAnnotationActions)
        }
        
        set {
            cuckoo_manager.setter("localAnnotationActions",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.localAnnotationActions = newValue)
        }
        
    }
    
    
    
    public var currentDvrWindowSize: Int? {
        get {
            return cuckoo_manager.getter("currentDvrWindowSize",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDvrWindowSize)
        }
        
        set {
            cuckoo_manager.setter("currentDvrWindowSize",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDvrWindowSize = newValue)
        }
        
    }
    
    
    
    public var currentRawSegmentPlaylist: String? {
        get {
            return cuckoo_manager.getter("currentRawSegmentPlaylist",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentRawSegmentPlaylist)
        }
        
        set {
            cuckoo_manager.setter("currentRawSegmentPlaylist",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentRawSegmentPlaylist = newValue)
        }
        
    }
    

    

    
    
    
    public func evaluate()  {
        
    return cuckoo_manager.call("evaluate()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.evaluate())
        
    }
    

	public struct __StubbingProxy_AnnotationIntegration: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var timelineId: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockAnnotationIntegration, String> {
	        return .init(manager: cuckoo_manager, name: "timelineId")
	    }
	    
	    
	    var localAnnotationActions: Cuckoo.ProtocolToBeStubbedProperty<MockAnnotationIntegration, [AnnotationAction]> {
	        return .init(manager: cuckoo_manager, name: "localAnnotationActions")
	    }
	    
	    
	    var currentDvrWindowSize: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockAnnotationIntegration, Int> {
	        return .init(manager: cuckoo_manager, name: "currentDvrWindowSize")
	    }
	    
	    
	    var currentRawSegmentPlaylist: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockAnnotationIntegration, String> {
	        return .init(manager: cuckoo_manager, name: "currentRawSegmentPlaylist")
	    }
	    
	    
	    func evaluate() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAnnotationIntegration.self, method: "evaluate()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AnnotationIntegration: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var timelineId: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "timelineId", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var localAnnotationActions: Cuckoo.VerifyProperty<[AnnotationAction]> {
	        return .init(manager: cuckoo_manager, name: "localAnnotationActions", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentDvrWindowSize: Cuckoo.VerifyOptionalProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "currentDvrWindowSize", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentRawSegmentPlaylist: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "currentRawSegmentPlaylist", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func evaluate() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("evaluate()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AnnotationIntegrationStub: AnnotationIntegration {
    
    
    public var timelineId: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
    public var localAnnotationActions: [AnnotationAction] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AnnotationAction]).self)
        }
        
        set { }
        
    }
    
    
    public var currentDvrWindowSize: Int? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int?).self)
        }
        
        set { }
        
    }
    
    
    public var currentRawSegmentPlaylist: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    

    

    
    public func evaluate()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}



public class MockAnnotationIntegrationView: AnnotationIntegrationView, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AnnotationIntegrationView
    
    public typealias Stubbing = __StubbingProxy_AnnotationIntegrationView
    public typealias Verification = __VerificationProxy_AnnotationIntegrationView

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnnotationIntegrationView?

    public func enableDefaultImplementation(_ stub: AnnotationIntegrationView) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var overlayContainerView: UIView {
        get {
            return cuckoo_manager.getter("overlayContainerView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.overlayContainerView)
        }
        
    }
    

    

    
    
    
    public func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])  {
        
    return cuckoo_manager.call("setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])",
            parameters: (actions),
            escapingParameters: (actions),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setTimelineMarkers(with: actions))
        
    }
    

	public struct __StubbingProxy_AnnotationIntegrationView: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var overlayContainerView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnnotationIntegrationView, UIView> {
	        return .init(manager: cuckoo_manager, name: "overlayContainerView")
	    }
	    
	    
	    func setTimelineMarkers<M1: Cuckoo.Matchable>(with actions: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([MLSUI.ShowTimelineMarkerAction])> where M1.MatchedType == [MLSUI.ShowTimelineMarkerAction] {
	        let matchers: [Cuckoo.ParameterMatcher<([MLSUI.ShowTimelineMarkerAction])>] = [wrap(matchable: actions) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAnnotationIntegrationView.self, method: "setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_AnnotationIntegrationView: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var overlayContainerView: Cuckoo.VerifyReadOnlyProperty<UIView> {
	        return .init(manager: cuckoo_manager, name: "overlayContainerView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func setTimelineMarkers<M1: Cuckoo.Matchable>(with actions: M1) -> Cuckoo.__DoNotUse<([MLSUI.ShowTimelineMarkerAction]), Void> where M1.MatchedType == [MLSUI.ShowTimelineMarkerAction] {
	        let matchers: [Cuckoo.ParameterMatcher<([MLSUI.ShowTimelineMarkerAction])>] = [wrap(matchable: actions) { $0 }]
	        return cuckoo_manager.verify("setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class AnnotationIntegrationViewStub: AnnotationIntegrationView {
    
    
    public var overlayContainerView: UIView {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIView).self)
        }
        
    }
    

    

    
    public func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/App/Core/CastIntegration.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


public class MockCastIntegration: CastIntegration, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CastIntegration
    
    public typealias Stubbing = __StubbingProxy_CastIntegration
    public typealias Verification = __VerificationProxy_CastIntegration

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CastIntegration?

    public func enableDefaultImplementation(_ stub: CastIntegration) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func initialize(_ videoPlayerDelegate: CastIntegrationVideoPlayerDelegate)  {
        
    return cuckoo_manager.call("initialize(_: CastIntegrationVideoPlayerDelegate)",
            parameters: (videoPlayerDelegate),
            escapingParameters: (videoPlayerDelegate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.initialize(videoPlayerDelegate))
        
    }
    
    
    
    public func isCasting() -> Bool {
        
    return cuckoo_manager.call("isCasting() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isCasting())
        
    }
    
    
    
    public func player() -> CastPlayerProtocol {
        
    return cuckoo_manager.call("player() -> CastPlayerProtocol",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.player())
        
    }
    

	public struct __StubbingProxy_CastIntegration: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func initialize<M1: Cuckoo.Matchable>(_ videoPlayerDelegate: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(CastIntegrationVideoPlayerDelegate)> where M1.MatchedType == CastIntegrationVideoPlayerDelegate {
	        let matchers: [Cuckoo.ParameterMatcher<(CastIntegrationVideoPlayerDelegate)>] = [wrap(matchable: videoPlayerDelegate) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCastIntegration.self, method: "initialize(_: CastIntegrationVideoPlayerDelegate)", parameterMatchers: matchers))
	    }
	    
	    func isCasting() -> Cuckoo.ProtocolStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCastIntegration.self, method: "isCasting() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func player() -> Cuckoo.ProtocolStubFunction<(), CastPlayerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCastIntegration.self, method: "player() -> CastPlayerProtocol", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CastIntegration: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func initialize<M1: Cuckoo.Matchable>(_ videoPlayerDelegate: M1) -> Cuckoo.__DoNotUse<(CastIntegrationVideoPlayerDelegate), Void> where M1.MatchedType == CastIntegrationVideoPlayerDelegate {
	        let matchers: [Cuckoo.ParameterMatcher<(CastIntegrationVideoPlayerDelegate)>] = [wrap(matchable: videoPlayerDelegate) { $0 }]
	        return cuckoo_manager.verify("initialize(_: CastIntegrationVideoPlayerDelegate)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func isCasting() -> Cuckoo.__DoNotUse<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("isCasting() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func player() -> Cuckoo.__DoNotUse<(), CastPlayerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("player() -> CastPlayerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class CastIntegrationStub: CastIntegration {
    

    

    
    public func initialize(_ videoPlayerDelegate: CastIntegrationVideoPlayerDelegate)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isCasting() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func player() -> CastPlayerProtocol  {
        return DefaultValueRegistry.defaultValue(for: (CastPlayerProtocol).self)
    }
    
}



public class MockCastIntegrationVideoPlayerDelegate: CastIntegrationVideoPlayerDelegate, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CastIntegrationVideoPlayerDelegate
    
    public typealias Stubbing = __StubbingProxy_CastIntegrationVideoPlayerDelegate
    public typealias Verification = __VerificationProxy_CastIntegrationVideoPlayerDelegate

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CastIntegrationVideoPlayerDelegate?

    public func enableDefaultImplementation(_ stub: CastIntegrationVideoPlayerDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func isCastingStateUpdated()  {
        
    return cuckoo_manager.call("isCastingStateUpdated()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isCastingStateUpdated())
        
    }
    

	public struct __StubbingProxy_CastIntegrationVideoPlayerDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func isCastingStateUpdated() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCastIntegrationVideoPlayerDelegate.self, method: "isCastingStateUpdated()", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CastIntegrationVideoPlayerDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func isCastingStateUpdated() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("isCastingStateUpdated()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class CastIntegrationVideoPlayerDelegateStub: CastIntegrationVideoPlayerDelegate {
    

    

    
    public func isCastingStateUpdated()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}



public class MockCastPlayerProtocol: CastPlayerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = CastPlayerProtocol
    
    public typealias Stubbing = __StubbingProxy_CastPlayerProtocol
    public typealias Verification = __VerificationProxy_CastPlayerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CastPlayerProtocol?

    public func enableDefaultImplementation(_ stub: CastPlayerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var state: PlayerState {
        get {
            return cuckoo_manager.getter("state",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.state)
        }
        
    }
    
    
    
    public var isMuted: Bool {
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
    
    
    
    public var currentDuration: Double {
        get {
            return cuckoo_manager.getter("currentDuration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDuration)
        }
        
    }
    
    
    
    public var currentTime: Double {
        get {
            return cuckoo_manager.getter("currentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentTime)
        }
        
    }
    
    
    
    public var optimisticCurrentTime: Double {
        get {
            return cuckoo_manager.getter("optimisticCurrentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.optimisticCurrentTime)
        }
        
    }
    
    
    
    public var isSeeking: Bool {
        get {
            return cuckoo_manager.getter("isSeeking",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isSeeking)
        }
        
    }
    
    
    
    public var isBuffering: Bool {
        get {
            return cuckoo_manager.getter("isBuffering",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isBuffering)
        }
        
    }
    
    
    
    public var isLivestream: Bool {
        get {
            return cuckoo_manager.getter("isLivestream",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isLivestream)
        }
        
    }
    
    
    
    public var currentItemEnded: Bool {
        get {
            return cuckoo_manager.getter("currentItemEnded",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemEnded)
        }
        
    }
    
    
    
    public var stateObserverCallback: (() -> Void)? {
        get {
            return cuckoo_manager.getter("stateObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stateObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("stateObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stateObserverCallback = newValue)
        }
        
    }
    
    
    
    public var timeObserverCallback: (() -> Void)? {
        get {
            return cuckoo_manager.getter("timeObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timeObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("timeObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timeObserverCallback = newValue)
        }
        
    }
    
    
    
    public var playObserverCallback: ((Bool) -> Void)? {
        get {
            return cuckoo_manager.getter("playObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("playObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playObserverCallback = newValue)
        }
        
    }
    
    
    
    public var rate: Float {
        get {
            return cuckoo_manager.getter("rate",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.rate)
        }
        
    }
    

    

    
    
    
    public func replaceCurrentItem(publicKey: @escaping () -> String?, identityToken: @escaping () -> String?, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("replaceCurrentItem(publicKey: @escaping () -> String?, identityToken: @escaping () -> String?, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void)",
            parameters: (publicKey, identityToken, pseudoUserId, event, stream, completionHandler),
            escapingParameters: (publicKey, identityToken, pseudoUserId, event, stream, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.replaceCurrentItem(publicKey: publicKey, identityToken: identityToken, pseudoUserId: pseudoUserId, event: event, stream: stream, completionHandler: completionHandler))
        
    }
    
    
    
    public func setRate(_ rate: Float)  {
        
    return cuckoo_manager.call("setRate(_: Float)",
            parameters: (rate),
            escapingParameters: (rate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setRate(rate))
        
    }
    
    
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler))
        
    }
    
    
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    
    
    
    public func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(by: amount, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    

	public struct __StubbingProxy_CastPlayerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var state: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, PlayerState> {
	        return .init(manager: cuckoo_manager, name: "state")
	    }
	    
	    
	    var isMuted: Cuckoo.ProtocolToBeStubbedProperty<MockCastPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted")
	    }
	    
	    
	    var currentDuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration")
	    }
	    
	    
	    var currentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentTime")
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime")
	    }
	    
	    
	    var isSeeking: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isSeeking")
	    }
	    
	    
	    var isBuffering: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isBuffering")
	    }
	    
	    
	    var isLivestream: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isLivestream")
	    }
	    
	    
	    var currentItemEnded: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemEnded")
	    }
	    
	    
	    var stateObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCastPlayerProtocol, (() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "stateObserverCallback")
	    }
	    
	    
	    var timeObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCastPlayerProtocol, (() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "timeObserverCallback")
	    }
	    
	    
	    var playObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockCastPlayerProtocol, ((Bool) -> Void)> {
	        return .init(manager: cuckoo_manager, name: "playObserverCallback")
	    }
	    
	    
	    var rate: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockCastPlayerProtocol, Float> {
	        return .init(manager: cuckoo_manager, name: "rate")
	    }
	    
	    
	    func replaceCurrentItem<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable>(publicKey: M1, identityToken: M2, pseudoUserId: M3, event: M4, stream: M5, completionHandler: M6) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> String?, () -> String?, String, MLSSDK.Event?, MLSSDK.Stream?, (Bool) -> Void)> where M1.MatchedType == () -> String?, M2.MatchedType == () -> String?, M3.MatchedType == String, M4.OptionalMatchedType == MLSSDK.Event, M5.OptionalMatchedType == MLSSDK.Stream, M6.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> String?, () -> String?, String, MLSSDK.Event?, MLSSDK.Stream?, (Bool) -> Void)>] = [wrap(matchable: publicKey) { $0.0 }, wrap(matchable: identityToken) { $0.1 }, wrap(matchable: pseudoUserId) { $0.2 }, wrap(matchable: event) { $0.3 }, wrap(matchable: stream) { $0.4 }, wrap(matchable: completionHandler) { $0.5 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCastPlayerProtocol.self, method: "replaceCurrentItem(publicKey: @escaping () -> String?, identityToken: @escaping () -> String?, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func setRate<M1: Cuckoo.Matchable>(_ rate: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Float)> where M1.MatchedType == Float {
	        let matchers: [Cuckoo.ParameterMatcher<(Float)>] = [wrap(matchable: rate) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCastPlayerProtocol.self, method: "setRate(_: Float)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, completionHandler: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: completionHandler) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCastPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCastPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(by amount: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(Double, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == Double, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: amount) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCastPlayerProtocol.self, method: "seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_CastPlayerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var state: Cuckoo.VerifyReadOnlyProperty<PlayerState> {
	        return .init(manager: cuckoo_manager, name: "state", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isMuted: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    
	    
	    var isBuffering: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isBuffering", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isLivestream: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isLivestream", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemEnded: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemEnded", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var stateObserverCallback: Cuckoo.VerifyOptionalProperty<(() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "stateObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var timeObserverCallback: Cuckoo.VerifyOptionalProperty<(() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "timeObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var playObserverCallback: Cuckoo.VerifyOptionalProperty<((Bool) -> Void)> {
	        return .init(manager: cuckoo_manager, name: "playObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var rate: Cuckoo.VerifyReadOnlyProperty<Float> {
	        return .init(manager: cuckoo_manager, name: "rate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func replaceCurrentItem<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable>(publicKey: M1, identityToken: M2, pseudoUserId: M3, event: M4, stream: M5, completionHandler: M6) -> Cuckoo.__DoNotUse<(() -> String?, () -> String?, String, MLSSDK.Event?, MLSSDK.Stream?, (Bool) -> Void), Void> where M1.MatchedType == () -> String?, M2.MatchedType == () -> String?, M3.MatchedType == String, M4.OptionalMatchedType == MLSSDK.Event, M5.OptionalMatchedType == MLSSDK.Stream, M6.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(() -> String?, () -> String?, String, MLSSDK.Event?, MLSSDK.Stream?, (Bool) -> Void)>] = [wrap(matchable: publicKey) { $0.0 }, wrap(matchable: identityToken) { $0.1 }, wrap(matchable: pseudoUserId) { $0.2 }, wrap(matchable: event) { $0.3 }, wrap(matchable: stream) { $0.4 }, wrap(matchable: completionHandler) { $0.5 }]
	        return cuckoo_manager.verify("replaceCurrentItem(publicKey: @escaping () -> String?, identityToken: @escaping () -> String?, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setRate<M1: Cuckoo.Matchable>(_ rate: M1) -> Cuckoo.__DoNotUse<(Float), Void> where M1.MatchedType == Float {
	        let matchers: [Cuckoo.ParameterMatcher<(Float)>] = [wrap(matchable: rate) { $0 }]
	        return cuckoo_manager.verify("setRate(_: Float)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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

public class CastPlayerProtocolStub: CastPlayerProtocol {
    
    
    public var state: PlayerState {
        get {
            return DefaultValueRegistry.defaultValue(for: (PlayerState).self)
        }
        
    }
    
    
    public var isMuted: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    public var currentDuration: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var currentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var optimisticCurrentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var isSeeking: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var isBuffering: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var isLivestream: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var currentItemEnded: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var stateObserverCallback: (() -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((() -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var timeObserverCallback: (() -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((() -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var playObserverCallback: ((Bool) -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: (((Bool) -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var rate: Float {
        get {
            return DefaultValueRegistry.defaultValue(for: (Float).self)
        }
        
    }
    

    

    
    public func replaceCurrentItem(publicKey: @escaping () -> String?, identityToken: @escaping () -> String?, pseudoUserId: String, event: MLSSDK.Event?, stream: MLSSDK.Stream?, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setRate(_ rate: Float)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/App/Core/IMAIntegration.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import AVFoundation
import Foundation


public class MockIMAIntegration: IMAIntegration, Cuckoo.ProtocolMock {
    
    public typealias MocksType = IMAIntegration
    
    public typealias Stubbing = __StubbingProxy_IMAIntegration
    public typealias Verification = __VerificationProxy_IMAIntegration

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: IMAIntegration?

    public func enableDefaultImplementation(_ stub: IMAIntegration) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func setAVPlayer(_ avPlayer: AVPlayer)  {
        
    return cuckoo_manager.call("setAVPlayer(_: AVPlayer)",
            parameters: (avPlayer),
            escapingParameters: (avPlayer),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setAVPlayer(avPlayer))
        
    }
    
    
    
    public func setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: EventStatus?)  {
        
    return cuckoo_manager.call("setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: EventStatus?)",
            parameters: (eventId, streamId, eventStatus),
            escapingParameters: (eventId, streamId, eventStatus),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setBasicCustomParameters(eventId: eventId, streamId: streamId, eventStatus: eventStatus))
        
    }
    
    
    
    public func setAdUnit(_ adUnit: String?)  {
        
    return cuckoo_manager.call("setAdUnit(_: String?)",
            parameters: (adUnit),
            escapingParameters: (adUnit),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setAdUnit(adUnit))
        
    }
    
    
    
    public func playPreroll()  {
        
    return cuckoo_manager.call("playPreroll()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.playPreroll())
        
    }
    
    
    
    public func playPostroll()  {
        
    return cuckoo_manager.call("playPostroll()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.playPostroll())
        
    }
    
    
    
    public func isShowingAd() -> Bool {
        
    return cuckoo_manager.call("isShowingAd() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isShowingAd())
        
    }
    
    
    
    public func pause()  {
        
    return cuckoo_manager.call("pause()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.pause())
        
    }
    
    
    
    public func resume()  {
        
    return cuckoo_manager.call("resume()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.resume())
        
    }
    
    
    
    public func adIsPaused() -> Bool {
        
    return cuckoo_manager.call("adIsPaused() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.adIsPaused())
        
    }
    

	public struct __StubbingProxy_IMAIntegration: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func setAVPlayer<M1: Cuckoo.Matchable>(_ avPlayer: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AVPlayer)> where M1.MatchedType == AVPlayer {
	        let matchers: [Cuckoo.ParameterMatcher<(AVPlayer)>] = [wrap(matchable: avPlayer) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "setAVPlayer(_: AVPlayer)", parameterMatchers: matchers))
	    }
	    
	    func setBasicCustomParameters<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(eventId: M1, streamId: M2, eventStatus: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?, EventStatus?)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.OptionalMatchedType == EventStatus {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?, EventStatus?)>] = [wrap(matchable: eventId) { $0.0 }, wrap(matchable: streamId) { $0.1 }, wrap(matchable: eventStatus) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: EventStatus?)", parameterMatchers: matchers))
	    }
	    
	    func setAdUnit<M1: Cuckoo.OptionalMatchable>(_ adUnit: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String?)> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: adUnit) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "setAdUnit(_: String?)", parameterMatchers: matchers))
	    }
	    
	    func playPreroll() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "playPreroll()", parameterMatchers: matchers))
	    }
	    
	    func playPostroll() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "playPostroll()", parameterMatchers: matchers))
	    }
	    
	    func isShowingAd() -> Cuckoo.ProtocolStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "isShowingAd() -> Bool", parameterMatchers: matchers))
	    }
	    
	    func pause() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "pause()", parameterMatchers: matchers))
	    }
	    
	    func resume() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "resume()", parameterMatchers: matchers))
	    }
	    
	    func adIsPaused() -> Cuckoo.ProtocolStubFunction<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockIMAIntegration.self, method: "adIsPaused() -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_IMAIntegration: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func setAVPlayer<M1: Cuckoo.Matchable>(_ avPlayer: M1) -> Cuckoo.__DoNotUse<(AVPlayer), Void> where M1.MatchedType == AVPlayer {
	        let matchers: [Cuckoo.ParameterMatcher<(AVPlayer)>] = [wrap(matchable: avPlayer) { $0 }]
	        return cuckoo_manager.verify("setAVPlayer(_: AVPlayer)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setBasicCustomParameters<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(eventId: M1, streamId: M2, eventStatus: M3) -> Cuckoo.__DoNotUse<(String?, String?, EventStatus?), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String, M3.OptionalMatchedType == EventStatus {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?, EventStatus?)>] = [wrap(matchable: eventId) { $0.0 }, wrap(matchable: streamId) { $0.1 }, wrap(matchable: eventStatus) { $0.2 }]
	        return cuckoo_manager.verify("setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: EventStatus?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setAdUnit<M1: Cuckoo.OptionalMatchable>(_ adUnit: M1) -> Cuckoo.__DoNotUse<(String?), Void> where M1.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?)>] = [wrap(matchable: adUnit) { $0 }]
	        return cuckoo_manager.verify("setAdUnit(_: String?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func playPreroll() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("playPreroll()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func playPostroll() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("playPostroll()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func isShowingAd() -> Cuckoo.__DoNotUse<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("isShowingAd() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func pause() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("pause()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resume() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resume()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func adIsPaused() -> Cuckoo.__DoNotUse<(), Bool> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("adIsPaused() -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class IMAIntegrationStub: IMAIntegration {
    

    

    
    public func setAVPlayer(_ avPlayer: AVPlayer)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setBasicCustomParameters(eventId: String?, streamId: String?, eventStatus: EventStatus?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setAdUnit(_ adUnit: String?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func playPreroll()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func playPostroll()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isShowingAd() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func pause()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func resume()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func adIsPaused() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/App/Core/MLSPlayerProtocol.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import AVFoundation
import Foundation


 class MockMLSPlayerProtocol: MLSPlayerProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = MLSPlayerProtocol
    
     typealias Stubbing = __StubbingProxy_MLSPlayerProtocol
     typealias Verification = __VerificationProxy_MLSPlayerProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSPlayerProtocol?

     func enableDefaultImplementation(_ stub: MLSPlayerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
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
    
    
    
     var status: AVPlayer.Status {
        get {
            return cuckoo_manager.getter("status",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.status)
        }
        
    }
    
    
    
     var rawSegmentPlaylist: String? {
        get {
            return cuckoo_manager.getter("rawSegmentPlaylist",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.rawSegmentPlaylist)
        }
        
    }
    
    
    
     var allowsExternalPlayback: Bool {
        get {
            return cuckoo_manager.getter("allowsExternalPlayback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.allowsExternalPlayback)
        }
        
        set {
            cuckoo_manager.setter("allowsExternalPlayback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.allowsExternalPlayback = newValue)
        }
        
    }
    
    
    
    public var state: PlayerState {
        get {
            return cuckoo_manager.getter("state",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.state)
        }
        
    }
    
    
    
    public var isMuted: Bool {
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
    
    
    
    public var currentDuration: Double {
        get {
            return cuckoo_manager.getter("currentDuration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDuration)
        }
        
    }
    
    
    
    public var currentTime: Double {
        get {
            return cuckoo_manager.getter("currentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentTime)
        }
        
    }
    
    
    
    public var optimisticCurrentTime: Double {
        get {
            return cuckoo_manager.getter("optimisticCurrentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.optimisticCurrentTime)
        }
        
    }
    
    
    
    public var isSeeking: Bool {
        get {
            return cuckoo_manager.getter("isSeeking",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isSeeking)
        }
        
    }
    
    
    
    public var isBuffering: Bool {
        get {
            return cuckoo_manager.getter("isBuffering",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isBuffering)
        }
        
    }
    
    
    
    public var isLivestream: Bool {
        get {
            return cuckoo_manager.getter("isLivestream",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isLivestream)
        }
        
    }
    
    
    
    public var currentItemEnded: Bool {
        get {
            return cuckoo_manager.getter("currentItemEnded",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemEnded)
        }
        
    }
    
    
    
    public var stateObserverCallback: (() -> Void)? {
        get {
            return cuckoo_manager.getter("stateObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stateObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("stateObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stateObserverCallback = newValue)
        }
        
    }
    
    
    
    public var timeObserverCallback: (() -> Void)? {
        get {
            return cuckoo_manager.getter("timeObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timeObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("timeObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timeObserverCallback = newValue)
        }
        
    }
    
    
    
    public var playObserverCallback: ((Bool) -> Void)? {
        get {
            return cuckoo_manager.getter("playObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("playObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playObserverCallback = newValue)
        }
        
    }
    
    
    
    public var rate: Float {
        get {
            return cuckoo_manager.getter("rate",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.rate)
        }
        
    }
    

    

    
    
    
     func replaceCurrentItem(with assetUrl: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ())  {
        
    return cuckoo_manager.call("replaceCurrentItem(with: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ())",
            parameters: (assetUrl, headers, resourceLoaderDelegate, callback),
            escapingParameters: (assetUrl, headers, resourceLoaderDelegate, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.replaceCurrentItem(with: assetUrl, headers: headers, resourceLoaderDelegate: resourceLoaderDelegate, callback: callback))
        
    }
    
    
    
    public func setRate(_ rate: Float)  {
        
    return cuckoo_manager.call("setRate(_: Float)",
            parameters: (rate),
            escapingParameters: (rate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setRate(rate))
        
    }
    
    
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler))
        
    }
    
    
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    
    
    
    public func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(by: amount, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    

	 struct __StubbingProxy_MLSPlayerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var currentItem: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, AVPlayerItem?> {
	        return .init(manager: cuckoo_manager, name: "currentItem")
	    }
	    
	    
	    var status: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, AVPlayer.Status> {
	        return .init(manager: cuckoo_manager, name: "status")
	    }
	    
	    
	    var rawSegmentPlaylist: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, String?> {
	        return .init(manager: cuckoo_manager, name: "rawSegmentPlaylist")
	    }
	    
	    
	    var allowsExternalPlayback: Cuckoo.ProtocolToBeStubbedProperty<MockMLSPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "allowsExternalPlayback")
	    }
	    
	    
	    var state: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, PlayerState> {
	        return .init(manager: cuckoo_manager, name: "state")
	    }
	    
	    
	    var isMuted: Cuckoo.ProtocolToBeStubbedProperty<MockMLSPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted")
	    }
	    
	    
	    var currentDuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration")
	    }
	    
	    
	    var currentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentTime")
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime")
	    }
	    
	    
	    var isSeeking: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isSeeking")
	    }
	    
	    
	    var isBuffering: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isBuffering")
	    }
	    
	    
	    var isLivestream: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isLivestream")
	    }
	    
	    
	    var currentItemEnded: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemEnded")
	    }
	    
	    
	    var stateObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockMLSPlayerProtocol, (() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "stateObserverCallback")
	    }
	    
	    
	    var timeObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockMLSPlayerProtocol, (() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "timeObserverCallback")
	    }
	    
	    
	    var playObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockMLSPlayerProtocol, ((Bool) -> Void)> {
	        return .init(manager: cuckoo_manager, name: "playObserverCallback")
	    }
	    
	    
	    var rate: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockMLSPlayerProtocol, Float> {
	        return .init(manager: cuckoo_manager, name: "rate")
	    }
	    
	    
	    func replaceCurrentItem<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(with assetUrl: M1, headers: M2, resourceLoaderDelegate: M3, callback: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(URL?, [String: String], AVAssetResourceLoaderDelegate?, (Bool) -> ())> where M1.OptionalMatchedType == URL, M2.MatchedType == [String: String], M3.OptionalMatchedType == AVAssetResourceLoaderDelegate, M4.MatchedType == (Bool) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL?, [String: String], AVAssetResourceLoaderDelegate?, (Bool) -> ())>] = [wrap(matchable: assetUrl) { $0.0 }, wrap(matchable: headers) { $0.1 }, wrap(matchable: resourceLoaderDelegate) { $0.2 }, wrap(matchable: callback) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSPlayerProtocol.self, method: "replaceCurrentItem(with: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ())", parameterMatchers: matchers))
	    }
	    
	    func setRate<M1: Cuckoo.Matchable>(_ rate: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Float)> where M1.MatchedType == Float {
	        let matchers: [Cuckoo.ParameterMatcher<(Float)>] = [wrap(matchable: rate) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSPlayerProtocol.self, method: "setRate(_: Float)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, completionHandler: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: completionHandler) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(by amount: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(Double, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == Double, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: amount) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSPlayerProtocol.self, method: "seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_MLSPlayerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var currentItem: Cuckoo.VerifyReadOnlyProperty<AVPlayerItem?> {
	        return .init(manager: cuckoo_manager, name: "currentItem", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var status: Cuckoo.VerifyReadOnlyProperty<AVPlayer.Status> {
	        return .init(manager: cuckoo_manager, name: "status", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var rawSegmentPlaylist: Cuckoo.VerifyReadOnlyProperty<String?> {
	        return .init(manager: cuckoo_manager, name: "rawSegmentPlaylist", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var allowsExternalPlayback: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "allowsExternalPlayback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var state: Cuckoo.VerifyReadOnlyProperty<PlayerState> {
	        return .init(manager: cuckoo_manager, name: "state", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isMuted: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    
	    
	    var isBuffering: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isBuffering", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isLivestream: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isLivestream", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemEnded: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemEnded", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var stateObserverCallback: Cuckoo.VerifyOptionalProperty<(() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "stateObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var timeObserverCallback: Cuckoo.VerifyOptionalProperty<(() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "timeObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var playObserverCallback: Cuckoo.VerifyOptionalProperty<((Bool) -> Void)> {
	        return .init(manager: cuckoo_manager, name: "playObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var rate: Cuckoo.VerifyReadOnlyProperty<Float> {
	        return .init(manager: cuckoo_manager, name: "rate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func replaceCurrentItem<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(with assetUrl: M1, headers: M2, resourceLoaderDelegate: M3, callback: M4) -> Cuckoo.__DoNotUse<(URL?, [String: String], AVAssetResourceLoaderDelegate?, (Bool) -> ()), Void> where M1.OptionalMatchedType == URL, M2.MatchedType == [String: String], M3.OptionalMatchedType == AVAssetResourceLoaderDelegate, M4.MatchedType == (Bool) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL?, [String: String], AVAssetResourceLoaderDelegate?, (Bool) -> ())>] = [wrap(matchable: assetUrl) { $0.0 }, wrap(matchable: headers) { $0.1 }, wrap(matchable: resourceLoaderDelegate) { $0.2 }, wrap(matchable: callback) { $0.3 }]
	        return cuckoo_manager.verify("replaceCurrentItem(with: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setRate<M1: Cuckoo.Matchable>(_ rate: M1) -> Cuckoo.__DoNotUse<(Float), Void> where M1.MatchedType == Float {
	        let matchers: [Cuckoo.ParameterMatcher<(Float)>] = [wrap(matchable: rate) { $0 }]
	        return cuckoo_manager.verify("setRate(_: Float)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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

 class MLSPlayerProtocolStub: MLSPlayerProtocol {
    
    
     var currentItem: AVPlayerItem? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVPlayerItem?).self)
        }
        
    }
    
    
     var status: AVPlayer.Status {
        get {
            return DefaultValueRegistry.defaultValue(for: (AVPlayer.Status).self)
        }
        
    }
    
    
     var rawSegmentPlaylist: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
    }
    
    
     var allowsExternalPlayback: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    public var state: PlayerState {
        get {
            return DefaultValueRegistry.defaultValue(for: (PlayerState).self)
        }
        
    }
    
    
    public var isMuted: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    public var currentDuration: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var currentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var optimisticCurrentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var isSeeking: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var isBuffering: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var isLivestream: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var currentItemEnded: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var stateObserverCallback: (() -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((() -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var timeObserverCallback: (() -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((() -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var playObserverCallback: ((Bool) -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: (((Bool) -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var rate: Float {
        get {
            return DefaultValueRegistry.defaultValue(for: (Float).self)
        }
        
    }
    

    

    
     func replaceCurrentItem(with assetUrl: URL?, headers: [String: String], resourceLoaderDelegate: AVAssetResourceLoaderDelegate?, callback: @escaping (Bool) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setRate(_ rate: Float)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/App/Core/PlayerProtocol.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import AVFoundation
import Foundation


public class MockPlayerProtocol: PlayerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PlayerProtocol
    
    public typealias Stubbing = __StubbingProxy_PlayerProtocol
    public typealias Verification = __VerificationProxy_PlayerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PlayerProtocol?

    public func enableDefaultImplementation(_ stub: PlayerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    public var state: PlayerState {
        get {
            return cuckoo_manager.getter("state",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.state)
        }
        
    }
    
    
    
    public var isMuted: Bool {
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
    
    
    
    public var currentDuration: Double {
        get {
            return cuckoo_manager.getter("currentDuration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentDuration)
        }
        
    }
    
    
    
    public var currentTime: Double {
        get {
            return cuckoo_manager.getter("currentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentTime)
        }
        
    }
    
    
    
    public var optimisticCurrentTime: Double {
        get {
            return cuckoo_manager.getter("optimisticCurrentTime",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.optimisticCurrentTime)
        }
        
    }
    
    
    
    public var isSeeking: Bool {
        get {
            return cuckoo_manager.getter("isSeeking",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isSeeking)
        }
        
    }
    
    
    
    public var isBuffering: Bool {
        get {
            return cuckoo_manager.getter("isBuffering",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isBuffering)
        }
        
    }
    
    
    
    public var isLivestream: Bool {
        get {
            return cuckoo_manager.getter("isLivestream",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isLivestream)
        }
        
    }
    
    
    
    public var currentItemEnded: Bool {
        get {
            return cuckoo_manager.getter("currentItemEnded",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemEnded)
        }
        
    }
    
    
    
    public var stateObserverCallback: (() -> Void)? {
        get {
            return cuckoo_manager.getter("stateObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stateObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("stateObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stateObserverCallback = newValue)
        }
        
    }
    
    
    
    public var timeObserverCallback: (() -> Void)? {
        get {
            return cuckoo_manager.getter("timeObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timeObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("timeObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.timeObserverCallback = newValue)
        }
        
    }
    
    
    
    public var playObserverCallback: ((Bool) -> Void)? {
        get {
            return cuckoo_manager.getter("playObserverCallback",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playObserverCallback)
        }
        
        set {
            cuckoo_manager.setter("playObserverCallback",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.playObserverCallback = newValue)
        }
        
    }
    
    
    
    public var rate: Float {
        get {
            return cuckoo_manager.getter("rate",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.rate)
        }
        
    }
    

    

    
    
    
    public func setRate(_ rate: Float)  {
        
    return cuckoo_manager.call("setRate(_: Float)",
            parameters: (rate),
            escapingParameters: (rate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setRate(rate))
        
    }
    
    
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler))
        
    }
    
    
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (time, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    
    
    
    public func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)  {
        
    return cuckoo_manager.call("seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)",
            parameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            escapingParameters: (amount, toleranceBefore, toleranceAfter, debounceSeconds, completionHandler),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.seek(by: amount, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, debounceSeconds: debounceSeconds, completionHandler: completionHandler))
        
    }
    

	public struct __StubbingProxy_PlayerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var state: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, PlayerState> {
	        return .init(manager: cuckoo_manager, name: "state")
	    }
	    
	    
	    var isMuted: Cuckoo.ProtocolToBeStubbedProperty<MockPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted")
	    }
	    
	    
	    var currentDuration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentDuration")
	    }
	    
	    
	    var currentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "currentTime")
	    }
	    
	    
	    var optimisticCurrentTime: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Double> {
	        return .init(manager: cuckoo_manager, name: "optimisticCurrentTime")
	    }
	    
	    
	    var isSeeking: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isSeeking")
	    }
	    
	    
	    var isBuffering: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isBuffering")
	    }
	    
	    
	    var isLivestream: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "isLivestream")
	    }
	    
	    
	    var currentItemEnded: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemEnded")
	    }
	    
	    
	    var stateObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockPlayerProtocol, (() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "stateObserverCallback")
	    }
	    
	    
	    var timeObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockPlayerProtocol, (() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "timeObserverCallback")
	    }
	    
	    
	    var playObserverCallback: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockPlayerProtocol, ((Bool) -> Void)> {
	        return .init(manager: cuckoo_manager, name: "playObserverCallback")
	    }
	    
	    
	    var rate: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPlayerProtocol, Float> {
	        return .init(manager: cuckoo_manager, name: "rate")
	    }
	    
	    
	    func setRate<M1: Cuckoo.Matchable>(_ rate: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Float)> where M1.MatchedType == Float {
	        let matchers: [Cuckoo.ParameterMatcher<(Float)>] = [wrap(matchable: rate) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPlayerProtocol.self, method: "setRate(_: Float)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, completionHandler: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: completionHandler) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(to time: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == CMTime, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(CMTime, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: time) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPlayerProtocol.self, method: "seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	    func seek<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(by amount: M1, toleranceBefore: M2, toleranceAfter: M3, debounceSeconds: M4, completionHandler: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(Double, CMTime, CMTime, Double, (Bool) -> Void)> where M1.MatchedType == Double, M2.MatchedType == CMTime, M3.MatchedType == CMTime, M4.MatchedType == Double, M5.MatchedType == (Bool) -> Void {
	        let matchers: [Cuckoo.ParameterMatcher<(Double, CMTime, CMTime, Double, (Bool) -> Void)>] = [wrap(matchable: amount) { $0.0 }, wrap(matchable: toleranceBefore) { $0.1 }, wrap(matchable: toleranceAfter) { $0.2 }, wrap(matchable: debounceSeconds) { $0.3 }, wrap(matchable: completionHandler) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPlayerProtocol.self, method: "seek(by: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_PlayerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var state: Cuckoo.VerifyReadOnlyProperty<PlayerState> {
	        return .init(manager: cuckoo_manager, name: "state", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isMuted: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isMuted", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
	    
	    
	    var isBuffering: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isBuffering", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isLivestream: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isLivestream", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemEnded: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemEnded", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var stateObserverCallback: Cuckoo.VerifyOptionalProperty<(() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "stateObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var timeObserverCallback: Cuckoo.VerifyOptionalProperty<(() -> Void)> {
	        return .init(manager: cuckoo_manager, name: "timeObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var playObserverCallback: Cuckoo.VerifyOptionalProperty<((Bool) -> Void)> {
	        return .init(manager: cuckoo_manager, name: "playObserverCallback", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var rate: Cuckoo.VerifyReadOnlyProperty<Float> {
	        return .init(manager: cuckoo_manager, name: "rate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func setRate<M1: Cuckoo.Matchable>(_ rate: M1) -> Cuckoo.__DoNotUse<(Float), Void> where M1.MatchedType == Float {
	        let matchers: [Cuckoo.ParameterMatcher<(Float)>] = [wrap(matchable: rate) { $0 }]
	        return cuckoo_manager.verify("setRate(_: Float)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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

public class PlayerProtocolStub: PlayerProtocol {
    
    
    public var state: PlayerState {
        get {
            return DefaultValueRegistry.defaultValue(for: (PlayerState).self)
        }
        
    }
    
    
    public var isMuted: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
    public var currentDuration: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var currentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var optimisticCurrentTime: Double {
        get {
            return DefaultValueRegistry.defaultValue(for: (Double).self)
        }
        
    }
    
    
    public var isSeeking: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var isBuffering: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var isLivestream: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var currentItemEnded: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    public var stateObserverCallback: (() -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((() -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var timeObserverCallback: (() -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((() -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var playObserverCallback: ((Bool) -> Void)? {
        get {
            return DefaultValueRegistry.defaultValue(for: (((Bool) -> Void)?).self)
        }
        
        set { }
        
    }
    
    
    public var rate: Float {
        get {
            return DefaultValueRegistry.defaultValue(for: (Float).self)
        }
        
    }
    

    

    
    public func setRate(_ rate: Float)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func seek(by amount: Double, toleranceBefore: CMTime, toleranceAfter: CMTime, debounceSeconds: Double, completionHandler: @escaping (Bool) -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/App/View/VideoPlayer/VideoPlayerViewProtocol+iOS.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

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
    
    
    
     var topLeadingControlsStackView: UIStackView {
        get {
            return cuckoo_manager.getter("topLeadingControlsStackView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.topLeadingControlsStackView)
        }
        
    }
    
    
    
     var topTrailingControlsStackView: UIStackView {
        get {
            return cuckoo_manager.getter("topTrailingControlsStackView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.topTrailingControlsStackView)
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
    
    
    
    public var overlayContainerView: UIView {
        get {
            return cuckoo_manager.getter("overlayContainerView",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.overlayContainerView)
        }
        
    }
    

    

    
    
    
     func drawPlayer(with player: MLSPlayerProtocol)  {
        
    return cuckoo_manager.call("drawPlayer(with: MLSPlayerProtocol)",
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
    
    
    
     func setControlViewVisibility(visible: Bool, withAnimationDuration: Double)  {
        
    return cuckoo_manager.call("setControlViewVisibility(visible: Bool, withAnimationDuration: Double)",
            parameters: (visible, withAnimationDuration),
            escapingParameters: (visible, withAnimationDuration),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setControlViewVisibility(visible: visible, withAnimationDuration: withAnimationDuration))
        
    }
    
    
    
     func setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)  {
        
    return cuckoo_manager.call("setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)",
            parameters: (visible, withAnimationDuration),
            escapingParameters: (visible, withAnimationDuration),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setInfoViewVisibility(visible: visible, withAnimationDuration: withAnimationDuration))
        
    }
    
    
    
     func setPlayButtonTo(state: VideoPlayerPlayButtonState)  {
        
    return cuckoo_manager.call("setPlayButtonTo(state: VideoPlayerPlayButtonState)",
            parameters: (state),
            escapingParameters: (state),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPlayButtonTo(state: state))
        
    }
    
    
    
     func setLiveButtonTo(state: VideoPlayerLiveState)  {
        
    return cuckoo_manager.call("setLiveButtonTo(state: VideoPlayerLiveState)",
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
    
    
    
     func setControlView(hidden: Bool)  {
        
    return cuckoo_manager.call("setControlView(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setControlView(hidden: hidden))
        
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
    
    
    
     func setAirplayButton(hidden: Bool)  {
        
    return cuckoo_manager.call("setAirplayButton(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setAirplayButton(hidden: hidden))
        
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
    
    
    
     func setTimeIndicatorLabel(hidden: Bool)  {
        
    return cuckoo_manager.call("setTimeIndicatorLabel(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setTimeIndicatorLabel(hidden: hidden))
        
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
    
    
    
     func setSeekbar(hidden: Bool)  {
        
    return cuckoo_manager.call("setSeekbar(hidden: Bool)",
            parameters: (hidden),
            escapingParameters: (hidden),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setSeekbar(hidden: hidden))
        
    }
    
    
    
    public func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])  {
        
    return cuckoo_manager.call("setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])",
            parameters: (actions),
            escapingParameters: (actions),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setTimelineMarkers(with: actions))
        
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
	    
	    
	    var topLeadingControlsStackView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UIStackView> {
	        return .init(manager: cuckoo_manager, name: "topLeadingControlsStackView")
	    }
	    
	    
	    var topTrailingControlsStackView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UIStackView> {
	        return .init(manager: cuckoo_manager, name: "topTrailingControlsStackView")
	    }
	    
	    
	    var fullscreenButtonIsHidden: Cuckoo.ProtocolToBeStubbedProperty<MockVideoPlayerViewProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "fullscreenButtonIsHidden")
	    }
	    
	    
	    var tapGestureRecognizer: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UITapGestureRecognizer> {
	        return .init(manager: cuckoo_manager, name: "tapGestureRecognizer")
	    }
	    
	    
	    var overlayContainerView: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockVideoPlayerViewProtocol, UIView> {
	        return .init(manager: cuckoo_manager, name: "overlayContainerView")
	    }
	    
	    
	    func drawPlayer<M1: Cuckoo.Matchable>(with player: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MLSPlayerProtocol)> where M1.MatchedType == MLSPlayerProtocol {
	        let matchers: [Cuckoo.ParameterMatcher<(MLSPlayerProtocol)>] = [wrap(matchable: player) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "drawPlayer(with: MLSPlayerProtocol)", parameterMatchers: matchers))
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
	    
	    func setControlViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, withAnimationDuration: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, Double)> where M1.MatchedType == Bool, M2.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Double)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: withAnimationDuration) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setControlViewVisibility(visible: Bool, withAnimationDuration: Double)", parameterMatchers: matchers))
	    }
	    
	    func setInfoViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, withAnimationDuration: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, Double)> where M1.MatchedType == Bool, M2.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Double)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: withAnimationDuration) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)", parameterMatchers: matchers))
	    }
	    
	    func setPlayButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoPlayerPlayButtonState)> where M1.MatchedType == VideoPlayerPlayButtonState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayerPlayButtonState)>] = [wrap(matchable: state) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setPlayButtonTo(state: VideoPlayerPlayButtonState)", parameterMatchers: matchers))
	    }
	    
	    func setLiveButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(VideoPlayerLiveState)> where M1.MatchedType == VideoPlayerLiveState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayerLiveState)>] = [wrap(matchable: state) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setLiveButtonTo(state: VideoPlayerLiveState)", parameterMatchers: matchers))
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
	    
	    func setControlView<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setControlView(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setBufferIcon<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setBufferIcon(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setInfoButton<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setInfoButton(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setAirplayButton<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setAirplayButton(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setSkipButtons<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setSkipButtons(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setTimeIndicatorLabel<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setTimeIndicatorLabel(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setTimeIndicatorLabel<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(elapsedText: M1, totalText: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String?, String?)> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?)>] = [wrap(matchable: elapsedText) { $0.0 }, wrap(matchable: totalText) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setTimeIndicatorLabel(elapsedText: String?, totalText: String?)", parameterMatchers: matchers))
	    }
	    
	    func setSeekbar<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setSeekbar(hidden: Bool)", parameterMatchers: matchers))
	    }
	    
	    func setTimelineMarkers<M1: Cuckoo.Matchable>(with actions: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([MLSUI.ShowTimelineMarkerAction])> where M1.MatchedType == [MLSUI.ShowTimelineMarkerAction] {
	        let matchers: [Cuckoo.ParameterMatcher<([MLSUI.ShowTimelineMarkerAction])>] = [wrap(matchable: actions) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoPlayerViewProtocol.self, method: "setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])", parameterMatchers: matchers))
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
	    
	    
	    var topLeadingControlsStackView: Cuckoo.VerifyReadOnlyProperty<UIStackView> {
	        return .init(manager: cuckoo_manager, name: "topLeadingControlsStackView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var topTrailingControlsStackView: Cuckoo.VerifyReadOnlyProperty<UIStackView> {
	        return .init(manager: cuckoo_manager, name: "topTrailingControlsStackView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var fullscreenButtonIsHidden: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "fullscreenButtonIsHidden", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var tapGestureRecognizer: Cuckoo.VerifyReadOnlyProperty<UITapGestureRecognizer> {
	        return .init(manager: cuckoo_manager, name: "tapGestureRecognizer", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var overlayContainerView: Cuckoo.VerifyReadOnlyProperty<UIView> {
	        return .init(manager: cuckoo_manager, name: "overlayContainerView", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func drawPlayer<M1: Cuckoo.Matchable>(with player: M1) -> Cuckoo.__DoNotUse<(MLSPlayerProtocol), Void> where M1.MatchedType == MLSPlayerProtocol {
	        let matchers: [Cuckoo.ParameterMatcher<(MLSPlayerProtocol)>] = [wrap(matchable: player) { $0 }]
	        return cuckoo_manager.verify("drawPlayer(with: MLSPlayerProtocol)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
	    func setControlViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, withAnimationDuration: M2) -> Cuckoo.__DoNotUse<(Bool, Double), Void> where M1.MatchedType == Bool, M2.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Double)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: withAnimationDuration) { $0.1 }]
	        return cuckoo_manager.verify("setControlViewVisibility(visible: Bool, withAnimationDuration: Double)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setInfoViewVisibility<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(visible: M1, withAnimationDuration: M2) -> Cuckoo.__DoNotUse<(Bool, Double), Void> where M1.MatchedType == Bool, M2.MatchedType == Double {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, Double)>] = [wrap(matchable: visible) { $0.0 }, wrap(matchable: withAnimationDuration) { $0.1 }]
	        return cuckoo_manager.verify("setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setPlayButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.__DoNotUse<(VideoPlayerPlayButtonState), Void> where M1.MatchedType == VideoPlayerPlayButtonState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayerPlayButtonState)>] = [wrap(matchable: state) { $0 }]
	        return cuckoo_manager.verify("setPlayButtonTo(state: VideoPlayerPlayButtonState)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setLiveButtonTo<M1: Cuckoo.Matchable>(state: M1) -> Cuckoo.__DoNotUse<(VideoPlayerLiveState), Void> where M1.MatchedType == VideoPlayerLiveState {
	        let matchers: [Cuckoo.ParameterMatcher<(VideoPlayerLiveState)>] = [wrap(matchable: state) { $0 }]
	        return cuckoo_manager.verify("setLiveButtonTo(state: VideoPlayerLiveState)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
	    func setControlView<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setControlView(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
	    func setAirplayButton<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setAirplayButton(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setSkipButtons<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setSkipButtons(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setTimeIndicatorLabel<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setTimeIndicatorLabel(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setTimeIndicatorLabel<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(elapsedText: M1, totalText: M2) -> Cuckoo.__DoNotUse<(String?, String?), Void> where M1.OptionalMatchedType == String, M2.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String?, String?)>] = [wrap(matchable: elapsedText) { $0.0 }, wrap(matchable: totalText) { $0.1 }]
	        return cuckoo_manager.verify("setTimeIndicatorLabel(elapsedText: String?, totalText: String?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setSeekbar<M1: Cuckoo.Matchable>(hidden: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: hidden) { $0 }]
	        return cuckoo_manager.verify("setSeekbar(hidden: Bool)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func setTimelineMarkers<M1: Cuckoo.Matchable>(with actions: M1) -> Cuckoo.__DoNotUse<([MLSUI.ShowTimelineMarkerAction]), Void> where M1.MatchedType == [MLSUI.ShowTimelineMarkerAction] {
	        let matchers: [Cuckoo.ParameterMatcher<([MLSUI.ShowTimelineMarkerAction])>] = [wrap(matchable: actions) { $0 }]
	        return cuckoo_manager.verify("setTimelineMarkers(with: [MLSUI.ShowTimelineMarkerAction])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    
    
     var topLeadingControlsStackView: UIStackView {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIStackView).self)
        }
        
    }
    
    
     var topTrailingControlsStackView: UIStackView {
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
    
    
    public var overlayContainerView: UIView {
        get {
            return DefaultValueRegistry.defaultValue(for: (UIView).self)
        }
        
    }
    

    

    
     func drawPlayer(with player: MLSPlayerProtocol)   {
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
    
     func setControlViewVisibility(visible: Bool, withAnimationDuration: Double)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setInfoViewVisibility(visible: Bool, withAnimationDuration: Double)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setPlayButtonTo(state: VideoPlayerPlayButtonState)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setLiveButtonTo(state: VideoPlayerLiveState)   {
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
    
     func setControlView(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setBufferIcon(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setInfoButton(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setAirplayButton(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setSkipButtons(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setTimeIndicatorLabel(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setTimeIndicatorLabel(elapsedText: String?, totalText: String?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func setSeekbar(hidden: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setTimelineMarkers(with actions: [MLSUI.ShowTimelineMarkerAction])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/Domain/Repositories/MLSArbitraryDataRepository.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


public class MockMLSArbitraryDataRepository: MLSArbitraryDataRepository, Cuckoo.ProtocolMock {
    
    public typealias MocksType = MLSArbitraryDataRepository
    
    public typealias Stubbing = __StubbingProxy_MLSArbitraryDataRepository
    public typealias Verification = __VerificationProxy_MLSArbitraryDataRepository

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSArbitraryDataRepository?

    public func enableDefaultImplementation(_ stub: MLSArbitraryDataRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func fetchData(byURL url: URL, callback: @escaping (Data?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchData(byURL: URL, callback: @escaping (Data?, Error?) -> ())",
            parameters: (url, callback),
            escapingParameters: (url, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchData(byURL: url, callback: callback))
        
    }
    
    
    
    public func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchDataAsString(byURL: URL, callback: @escaping (String?, Error?) -> ())",
            parameters: (url, callback),
            escapingParameters: (url, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchDataAsString(byURL: url, callback: callback))
        
    }
    

	public struct __StubbingProxy_MLSArbitraryDataRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchData<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URL, (Data?, Error?) -> ())> where M1.MatchedType == URL, M2.MatchedType == (Data?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (Data?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSArbitraryDataRepository.self, method: "fetchData(byURL: URL, callback: @escaping (Data?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchDataAsString<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URL, (String?, Error?) -> ())> where M1.MatchedType == URL, M2.MatchedType == (String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (String?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSArbitraryDataRepository.self, method: "fetchDataAsString(byURL: URL, callback: @escaping (String?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_MLSArbitraryDataRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchData<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.__DoNotUse<(URL, (Data?, Error?) -> ()), Void> where M1.MatchedType == URL, M2.MatchedType == (Data?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (Data?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchData(byURL: URL, callback: @escaping (Data?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchDataAsString<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.__DoNotUse<(URL, (String?, Error?) -> ()), Void> where M1.MatchedType == URL, M2.MatchedType == (String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (String?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchDataAsString(byURL: URL, callback: @escaping (String?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class MLSArbitraryDataRepositoryStub: MLSArbitraryDataRepository {
    

    

    
    public func fetchData(byURL url: URL, callback: @escaping (Data?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchDataAsString(byURL url: URL, callback: @escaping (String?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/Domain/Repositories/MLSDRMRepository.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


public class MockMLSDRMRepository: MLSDRMRepository, Cuckoo.ProtocolMock {
    
    public typealias MocksType = MLSDRMRepository
    
    public typealias Stubbing = __StubbingProxy_MLSDRMRepository
    public typealias Verification = __VerificationProxy_MLSDRMRepository

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSDRMRepository?

    public func enableDefaultImplementation(_ stub: MLSDRMRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func fetchCertificate(byURL url: URL, callback: @escaping (Data?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchCertificate(byURL: URL, callback: @escaping (Data?, Error?) -> ())",
            parameters: (url, callback),
            escapingParameters: (url, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchCertificate(byURL: url, callback: callback))
        
    }
    
    
    
    public func fetchLicense(byURL url: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchLicense(byURL: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ())",
            parameters: (url, spcData, callback),
            escapingParameters: (url, spcData, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchLicense(byURL: url, spcData: spcData, callback: callback))
        
    }
    

	public struct __StubbingProxy_MLSDRMRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchCertificate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URL, (Data?, Error?) -> ())> where M1.MatchedType == URL, M2.MatchedType == (Data?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (Data?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSDRMRepository.self, method: "fetchCertificate(byURL: URL, callback: @escaping (Data?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchLicense<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(byURL url: M1, spcData: M2, callback: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(URL, Data, (Data?, Error?) -> ())> where M1.MatchedType == URL, M2.MatchedType == Data, M3.MatchedType == (Data?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, Data, (Data?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: spcData) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSDRMRepository.self, method: "fetchLicense(byURL: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_MLSDRMRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchCertificate<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byURL url: M1, callback: M2) -> Cuckoo.__DoNotUse<(URL, (Data?, Error?) -> ()), Void> where M1.MatchedType == URL, M2.MatchedType == (Data?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, (Data?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchCertificate(byURL: URL, callback: @escaping (Data?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchLicense<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(byURL url: M1, spcData: M2, callback: M3) -> Cuckoo.__DoNotUse<(URL, Data, (Data?, Error?) -> ()), Void> where M1.MatchedType == URL, M2.MatchedType == Data, M3.MatchedType == (Data?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(URL, Data, (Data?, Error?) -> ())>] = [wrap(matchable: url) { $0.0 }, wrap(matchable: spcData) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("fetchLicense(byURL: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class MLSDRMRepositoryStub: MLSDRMRepository {
    

    

    
    public func fetchCertificate(byURL url: URL, callback: @escaping (Data?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchLicense(byURL url: URL, spcData: Data, callback: @escaping (Data?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/Domain/Repositories/MLSEventRepository.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


public class MockMLSEventRepository: MLSEventRepository, Cuckoo.ProtocolMock {
    
    public typealias MocksType = MLSEventRepository
    
    public typealias Stubbing = __StubbingProxy_MLSEventRepository
    public typealias Verification = __VerificationProxy_MLSEventRepository

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSEventRepository?

    public func enableDefaultImplementation(_ stub: MLSEventRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchEvent(byId: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())",
            parameters: (id, updateId, callback),
            escapingParameters: (id, updateId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchEvent(byId: id, updateId: updateId, callback: callback))
        
    }
    
    
    
    public func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())",
            parameters: (pageSize, pageToken, status, orderBy, callback),
            escapingParameters: (pageSize, pageToken, status, orderBy, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchEvents(pageSize: pageSize, pageToken: pageToken, status: status, orderBy: orderBy, callback: callback))
        
    }
    
    
    
    public func startEventUpdates(for id: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ())  {
        
    return cuckoo_manager.call("startEventUpdates(for: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ())",
            parameters: (id, callback),
            escapingParameters: (id, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startEventUpdates(for: id, callback: callback))
        
    }
    
    
    
    public func stopEventUpdates(for id: String)  {
        
    return cuckoo_manager.call("stopEventUpdates(for: String)",
            parameters: (id),
            escapingParameters: (id),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopEventUpdates(for: id))
        
    }
    

	public struct __StubbingProxy_MLSEventRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchEvent<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(byId id: M1, updateId: M2, callback: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String?, (Event?, Error?) -> ())> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == (Event?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, (Event?, Error?) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: updateId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSEventRepository.self, method: "fetchEvent(byId: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchEvents<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable>(pageSize: M1, pageToken: M2, status: M3, orderBy: M4, callback: M5) -> Cuckoo.ProtocolStubNoReturnFunction<(Int?, String?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, String?, String?, Error?) -> ())> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.OptionalMatchedType == [ParamEventStatus], M4.OptionalMatchedType == ParamEventOrder, M5.MatchedType == ([Event]?, String?, String?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, String?, String?, Error?) -> ())>] = [wrap(matchable: pageSize) { $0.0 }, wrap(matchable: pageToken) { $0.1 }, wrap(matchable: status) { $0.2 }, wrap(matchable: orderBy) { $0.3 }, wrap(matchable: callback) { $0.4 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSEventRepository.self, method: "fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func startEventUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for id: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, (MLSEventRepositoryEventUpdate) -> ())> where M1.MatchedType == String, M2.MatchedType == (MLSEventRepositoryEventUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (MLSEventRepositoryEventUpdate) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSEventRepository.self, method: "startEventUpdates(for: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ())", parameterMatchers: matchers))
	    }
	    
	    func stopEventUpdates<M1: Cuckoo.Matchable>(for id: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSEventRepository.self, method: "stopEventUpdates(for: String)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_MLSEventRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
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
	    func startEventUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for id: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, (MLSEventRepositoryEventUpdate) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == (MLSEventRepositoryEventUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (MLSEventRepositoryEventUpdate) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("startEventUpdates(for: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopEventUpdates<M1: Cuckoo.Matchable>(for id: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
	        return cuckoo_manager.verify("stopEventUpdates(for: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class MLSEventRepositoryStub: MLSEventRepository {
    

    

    
    public func fetchEvent(byId id: String, updateId: String?, callback: @escaping (Event?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchEvents(pageSize: Int?, pageToken: String?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, String?, String?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startEventUpdates(for id: String, callback: @escaping (MLSEventRepositoryEventUpdate) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopEventUpdates(for id: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/Domain/Repositories/MLSPlayerConfigRepository.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


public class MockMLSPlayerConfigRepository: MLSPlayerConfigRepository, Cuckoo.ProtocolMock {
    
    public typealias MocksType = MLSPlayerConfigRepository
    
    public typealias Stubbing = __StubbingProxy_MLSPlayerConfigRepository
    public typealias Verification = __VerificationProxy_MLSPlayerConfigRepository

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSPlayerConfigRepository?

    public func enableDefaultImplementation(_ stub: MLSPlayerConfigRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())",
            parameters: (callback),
            escapingParameters: (callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchPlayerConfig(callback: callback))
        
    }
    

	public struct __StubbingProxy_MLSPlayerConfigRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchPlayerConfig<M1: Cuckoo.Matchable>(callback: M1) -> Cuckoo.ProtocolStubNoReturnFunction<((PlayerConfig?, Error?) -> ())> where M1.MatchedType == (PlayerConfig?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<((PlayerConfig?, Error?) -> ())>] = [wrap(matchable: callback) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSPlayerConfigRepository.self, method: "fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_MLSPlayerConfigRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
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

public class MLSPlayerConfigRepositoryStub: MLSPlayerConfigRepository {
    

    

    
    public func fetchPlayerConfig(callback: @escaping (PlayerConfig?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/Domain/Repositories/MLSTimelineRepository.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import Foundation


public class MockMLSTimelineRepository: MLSTimelineRepository, Cuckoo.ProtocolMock {
    
    public typealias MocksType = MLSTimelineRepository
    
    public typealias Stubbing = __StubbingProxy_MLSTimelineRepository
    public typealias Verification = __VerificationProxy_MLSTimelineRepository

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: MLSTimelineRepository?

    public func enableDefaultImplementation(_ stub: MLSTimelineRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    public func fetchAnnotationActions(byTimelineId timelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchAnnotationActions(byTimelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())",
            parameters: (timelineId, updateId, callback),
            escapingParameters: (timelineId, updateId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchAnnotationActions(byTimelineId: timelineId, updateId: updateId, callback: callback))
        
    }
    
    
    
    public func startTimelineUpdates(for timelineId: String, callback: @escaping (MLSTimelineRepositoryTimelineUpdate) -> ())  {
        
    return cuckoo_manager.call("startTimelineUpdates(for: String, callback: @escaping (MLSTimelineRepositoryTimelineUpdate) -> ())",
            parameters: (timelineId, callback),
            escapingParameters: (timelineId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startTimelineUpdates(for: timelineId, callback: callback))
        
    }
    
    
    
    public func stopTimelineUpdates(for timelineId: String)  {
        
    return cuckoo_manager.call("stopTimelineUpdates(for: String)",
            parameters: (timelineId),
            escapingParameters: (timelineId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopTimelineUpdates(for: timelineId))
        
    }
    

	public struct __StubbingProxy_MLSTimelineRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    public init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchAnnotationActions<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(byTimelineId timelineId: M1, updateId: M2, callback: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String?, ([AnnotationAction]?, Error?) -> ())> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == ([AnnotationAction]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, ([AnnotationAction]?, Error?) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: updateId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSTimelineRepository.self, method: "fetchAnnotationActions(byTimelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func startTimelineUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for timelineId: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, (MLSTimelineRepositoryTimelineUpdate) -> ())> where M1.MatchedType == String, M2.MatchedType == (MLSTimelineRepositoryTimelineUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (MLSTimelineRepositoryTimelineUpdate) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSTimelineRepository.self, method: "startTimelineUpdates(for: String, callback: @escaping (MLSTimelineRepositoryTimelineUpdate) -> ())", parameterMatchers: matchers))
	    }
	    
	    func stopTimelineUpdates<M1: Cuckoo.Matchable>(for timelineId: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: timelineId) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockMLSTimelineRepository.self, method: "stopTimelineUpdates(for: String)", parameterMatchers: matchers))
	    }
	    
	}

	public struct __VerificationProxy_MLSTimelineRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchAnnotationActions<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(byTimelineId timelineId: M1, updateId: M2, callback: M3) -> Cuckoo.__DoNotUse<(String, String?, ([AnnotationAction]?, Error?) -> ()), Void> where M1.MatchedType == String, M2.OptionalMatchedType == String, M3.MatchedType == ([AnnotationAction]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String?, ([AnnotationAction]?, Error?) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: updateId) { $0.1 }, wrap(matchable: callback) { $0.2 }]
	        return cuckoo_manager.verify("fetchAnnotationActions(byTimelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func startTimelineUpdates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for timelineId: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, (MLSTimelineRepositoryTimelineUpdate) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == (MLSTimelineRepositoryTimelineUpdate) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (MLSTimelineRepositoryTimelineUpdate) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("startTimelineUpdates(for: String, callback: @escaping (MLSTimelineRepositoryTimelineUpdate) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopTimelineUpdates<M1: Cuckoo.Matchable>(for timelineId: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: timelineId) { $0 }]
	        return cuckoo_manager.verify("stopTimelineUpdates(for: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

public class MLSTimelineRepositoryStub: MLSTimelineRepository {
    

    

    
    public func fetchAnnotationActions(byTimelineId timelineId: String, updateId: String?, callback: @escaping ([AnnotationAction]?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startTimelineUpdates(for timelineId: String, callback: @escaping (MLSTimelineRepositoryTimelineUpdate) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopTimelineUpdates(for timelineId: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Core/Domain/Services/VideoAnalyticsServicing.swift at 2021-12-01 11:37:14 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK
@testable import MLSSDK_Annotations

import AVFoundation
import Foundation


 class MockVideoAnalyticsServicing: VideoAnalyticsServicing, Cuckoo.ProtocolMock {
    
     typealias MocksType = VideoAnalyticsServicing
    
     typealias Stubbing = __StubbingProxy_VideoAnalyticsServicing
     typealias Verification = __VerificationProxy_VideoAnalyticsServicing

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: VideoAnalyticsServicing?

     func enableDefaultImplementation(_ stub: VideoAnalyticsServicing) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var analyticsAccount: String? {
        get {
            return cuckoo_manager.getter("analyticsAccount",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.analyticsAccount)
        }
        
        set {
            cuckoo_manager.setter("analyticsAccount",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.analyticsAccount = newValue)
        }
        
    }
    
    
    
     var userId: String? {
        get {
            return cuckoo_manager.getter("userId",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userId)
        }
        
        set {
            cuckoo_manager.setter("userId",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userId = newValue)
        }
        
    }
    
    
    
     var currentItemTitle: String? {
        get {
            return cuckoo_manager.getter("currentItemTitle",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemTitle)
        }
        
        set {
            cuckoo_manager.setter("currentItemTitle",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemTitle = newValue)
        }
        
    }
    
    
    
     var currentItemEventId: String? {
        get {
            return cuckoo_manager.getter("currentItemEventId",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemEventId)
        }
        
        set {
            cuckoo_manager.setter("currentItemEventId",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemEventId = newValue)
        }
        
    }
    
    
    
     var currentItemStreamId: String? {
        get {
            return cuckoo_manager.getter("currentItemStreamId",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemStreamId)
        }
        
        set {
            cuckoo_manager.setter("currentItemStreamId",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemStreamId = newValue)
        }
        
    }
    
    
    
     var currentItemStreamURL: URL? {
        get {
            return cuckoo_manager.getter("currentItemStreamURL",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemStreamURL)
        }
        
        set {
            cuckoo_manager.setter("currentItemStreamURL",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemStreamURL = newValue)
        }
        
    }
    
    
    
     var currentItemIsLive: Bool? {
        get {
            return cuckoo_manager.getter("currentItemIsLive",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemIsLive)
        }
        
        set {
            cuckoo_manager.setter("currentItemIsLive",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentItemIsLive = newValue)
        }
        
    }
    
    
    
     var isNativeMLS: Bool? {
        get {
            return cuckoo_manager.getter("isNativeMLS",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isNativeMLS)
        }
        
        set {
            cuckoo_manager.setter("isNativeMLS",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isNativeMLS = newValue)
        }
        
    }
    

    

    
    
    
     func create(with player: MLSPlayerProtocol)  {
        
    return cuckoo_manager.call("create(with: MLSPlayerProtocol)",
            parameters: (player),
            escapingParameters: (player),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.create(with: player))
        
    }
    
    
    
     func stop()  {
        
    return cuckoo_manager.call("stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stop())
        
    }
    

	 struct __StubbingProxy_VideoAnalyticsServicing: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var analyticsAccount: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, String> {
	        return .init(manager: cuckoo_manager, name: "analyticsAccount")
	    }
	    
	    
	    var userId: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, String> {
	        return .init(manager: cuckoo_manager, name: "userId")
	    }
	    
	    
	    var currentItemTitle: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, String> {
	        return .init(manager: cuckoo_manager, name: "currentItemTitle")
	    }
	    
	    
	    var currentItemEventId: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, String> {
	        return .init(manager: cuckoo_manager, name: "currentItemEventId")
	    }
	    
	    
	    var currentItemStreamId: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, String> {
	        return .init(manager: cuckoo_manager, name: "currentItemStreamId")
	    }
	    
	    
	    var currentItemStreamURL: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, URL> {
	        return .init(manager: cuckoo_manager, name: "currentItemStreamURL")
	    }
	    
	    
	    var currentItemIsLive: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemIsLive")
	    }
	    
	    
	    var isNativeMLS: Cuckoo.ProtocolToBeStubbedOptionalProperty<MockVideoAnalyticsServicing, Bool> {
	        return .init(manager: cuckoo_manager, name: "isNativeMLS")
	    }
	    
	    
	    func create<M1: Cuckoo.Matchable>(with player: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(MLSPlayerProtocol)> where M1.MatchedType == MLSPlayerProtocol {
	        let matchers: [Cuckoo.ParameterMatcher<(MLSPlayerProtocol)>] = [wrap(matchable: player) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoAnalyticsServicing.self, method: "create(with: MLSPlayerProtocol)", parameterMatchers: matchers))
	    }
	    
	    func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockVideoAnalyticsServicing.self, method: "stop()", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_VideoAnalyticsServicing: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var analyticsAccount: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "analyticsAccount", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var userId: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "userId", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemTitle: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "currentItemTitle", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemEventId: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "currentItemEventId", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemStreamId: Cuckoo.VerifyOptionalProperty<String> {
	        return .init(manager: cuckoo_manager, name: "currentItemStreamId", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemStreamURL: Cuckoo.VerifyOptionalProperty<URL> {
	        return .init(manager: cuckoo_manager, name: "currentItemStreamURL", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var currentItemIsLive: Cuckoo.VerifyOptionalProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "currentItemIsLive", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var isNativeMLS: Cuckoo.VerifyOptionalProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isNativeMLS", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func create<M1: Cuckoo.Matchable>(with player: M1) -> Cuckoo.__DoNotUse<(MLSPlayerProtocol), Void> where M1.MatchedType == MLSPlayerProtocol {
	        let matchers: [Cuckoo.ParameterMatcher<(MLSPlayerProtocol)>] = [wrap(matchable: player) { $0 }]
	        return cuckoo_manager.verify("create(with: MLSPlayerProtocol)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stop() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("stop()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class VideoAnalyticsServicingStub: VideoAnalyticsServicing {
    
    
     var analyticsAccount: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
     var userId: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
     var currentItemTitle: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
     var currentItemEventId: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
     var currentItemStreamId: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
        
        set { }
        
    }
    
    
     var currentItemStreamURL: URL? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL?).self)
        }
        
        set { }
        
    }
    
    
     var currentItemIsLive: Bool? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool?).self)
        }
        
        set { }
        
    }
    
    
     var isNativeMLS: Bool? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool?).self)
        }
        
        set { }
        
    }
    

    

    
     func create(with player: MLSPlayerProtocol)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func stop()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

