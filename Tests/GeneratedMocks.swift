// MARK: - Mocks generated from file: Sources/Services/APIServicing.swift at 2020-07-21 21:59:04 +0000

//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Cuckoo
@testable import MLSSDK

import Foundation


 class MockAPIServicing: APIServicing, Cuckoo.ProtocolMock {
    
     typealias MocksType = APIServicing
    
     typealias Stubbing = __StubbingProxy_APIServicing
     typealias Verification = __VerificationProxy_APIServicing

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: APIServicing?

     func enableDefaultImplementation(_ stub: APIServicing) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchEvent(byId: String, callback: @escaping (Event?, Error?) -> ())",
            parameters: (id, callback),
            escapingParameters: (id, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchEvent(byId: id, callback: callback))
        
    }
    
    
    
     func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())",
            parameters: (pageSize, pageToken, hasStream, status, orderBy, callback),
            escapingParameters: (pageSize, pageToken, hasStream, status, orderBy, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchEvents(pageSize: pageSize, pageToken: pageToken, hasStream: hasStream, status: status, orderBy: orderBy, callback: callback))
        
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
    
    
    
     func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())  {
        
    return cuckoo_manager.call("fetchPlayerConfig(byEventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())",
            parameters: (eventId, callback),
            escapingParameters: (eventId, callback),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchPlayerConfig(byEventId: eventId, callback: callback))
        
    }
    

	 struct __StubbingProxy_APIServicing: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func fetchEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byId id: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, (Event?, Error?) -> ())> where M1.MatchedType == String, M2.MatchedType == (Event?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (Event?, Error?) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAPIServicing.self, method: "fetchEvent(byId: String, callback: @escaping (Event?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchEvents<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable>(pageSize: M1, pageToken: M2, hasStream: M3, status: M4, orderBy: M5, callback: M6) -> Cuckoo.ProtocolStubNoReturnFunction<(Int?, String?, Bool?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, Error?) -> ())> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.OptionalMatchedType == Bool, M4.OptionalMatchedType == [ParamEventStatus], M5.OptionalMatchedType == ParamEventOrder, M6.MatchedType == ([Event]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, Bool?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, Error?) -> ())>] = [wrap(matchable: pageSize) { $0.0 }, wrap(matchable: pageToken) { $0.1 }, wrap(matchable: hasStream) { $0.2 }, wrap(matchable: status) { $0.3 }, wrap(matchable: orderBy) { $0.4 }, wrap(matchable: callback) { $0.5 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAPIServicing.self, method: "fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchAnnotationActions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byTimelineId timelineId: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, ([AnnotationAction]?, Error?) -> ())> where M1.MatchedType == String, M2.MatchedType == ([AnnotationAction]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, ([AnnotationAction]?, Error?) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAPIServicing.self, method: "fetchAnnotationActions(byTimelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	    func fetchPlayerConfig<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byEventId eventId: M1, callback: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, (PlayerConfig?, Error?) -> ())> where M1.MatchedType == String, M2.MatchedType == (PlayerConfig?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (PlayerConfig?, Error?) -> ())>] = [wrap(matchable: eventId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockAPIServicing.self, method: "fetchPlayerConfig(byEventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_APIServicing: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func fetchEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byId id: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, (Event?, Error?) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == (Event?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (Event?, Error?) -> ())>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchEvent(byId: String, callback: @escaping (Event?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchEvents<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable, M6: Cuckoo.Matchable>(pageSize: M1, pageToken: M2, hasStream: M3, status: M4, orderBy: M5, callback: M6) -> Cuckoo.__DoNotUse<(Int?, String?, Bool?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, Error?) -> ()), Void> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.OptionalMatchedType == Bool, M4.OptionalMatchedType == [ParamEventStatus], M5.OptionalMatchedType == ParamEventOrder, M6.MatchedType == ([Event]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, Bool?, [ParamEventStatus]?, ParamEventOrder?, ([Event]?, Error?) -> ())>] = [wrap(matchable: pageSize) { $0.0 }, wrap(matchable: pageToken) { $0.1 }, wrap(matchable: hasStream) { $0.2 }, wrap(matchable: status) { $0.3 }, wrap(matchable: orderBy) { $0.4 }, wrap(matchable: callback) { $0.5 }]
	        return cuckoo_manager.verify("fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchAnnotationActions<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byTimelineId timelineId: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, ([AnnotationAction]?, Error?) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == ([AnnotationAction]?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, ([AnnotationAction]?, Error?) -> ())>] = [wrap(matchable: timelineId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchAnnotationActions(byTimelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func fetchPlayerConfig<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byEventId eventId: M1, callback: M2) -> Cuckoo.__DoNotUse<(String, (PlayerConfig?, Error?) -> ()), Void> where M1.MatchedType == String, M2.MatchedType == (PlayerConfig?, Error?) -> () {
	        let matchers: [Cuckoo.ParameterMatcher<(String, (PlayerConfig?, Error?) -> ())>] = [wrap(matchable: eventId) { $0.0 }, wrap(matchable: callback) { $0.1 }]
	        return cuckoo_manager.verify("fetchPlayerConfig(byEventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class APIServicingStub: APIServicing {
    

    

    
     func fetchEvent(byId id: String, callback: @escaping (Event?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func fetchEvents(pageSize: Int?, pageToken: String?, hasStream: Bool?, status: [ParamEventStatus]?, orderBy: ParamEventOrder?, callback: @escaping ([Event]?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func fetchAnnotationActions(byTimelineId timelineId: String, callback: @escaping ([AnnotationAction]?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func fetchPlayerConfig(byEventId eventId: String, callback: @escaping (PlayerConfig?, Error?) -> ())   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: Sources/Services/AnnotationServicing.swift at 2020-07-21 21:59:04 +0000

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

