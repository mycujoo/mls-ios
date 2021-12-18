//
// Copyright © 2021 mycujoo. All rights reserved.
//


/// This struct can be used to provide custom data to the video analytics service. Provide the data that matches the analytics service you are using (Youbora by default).
public struct VideoAnalyticsCustomData {
    /// Some custom dimensions are reserved, and are therefore not available.
    public struct YouboraData {
        var contentCustomDimension1: String?
        var contentCustomDimension3: String?
        var contentCustomDimension4: String?
        var contentCustomDimension5: String?
        var contentCustomDimension6: String?
        var contentCustomDimension7: String?
        var contentCustomDimension8: String?
        var contentCustomDimension9: String?
        var contentCustomDimension10: String?
        var contentCustomDimension11: String?
        var contentCustomDimension13: String?
    }
    
    let youboraData: YouboraData?
}


