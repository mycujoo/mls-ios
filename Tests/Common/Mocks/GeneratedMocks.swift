// MARK: - Mocks generated from file: Sources/Domain/Services/AnnotationServicing.swift at 2020-07-26 20:19:53 +0000

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

