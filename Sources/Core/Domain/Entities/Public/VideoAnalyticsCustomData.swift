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
        
        public init(
            contentCustomDimension1: String?,
            contentCustomDimension3: String?,
            contentCustomDimension4: String?,
            contentCustomDimension5: String?,
            contentCustomDimension6: String?,
            contentCustomDimension7: String?,
            contentCustomDimension8: String?,
            contentCustomDimension9: String?,
            contentCustomDimension10: String?,
            contentCustomDimension11: String?,
            contentCustomDimension13: String?
        ) {
            self.contentCustomDimension1 = contentCustomDimension1
            self.contentCustomDimension3 = contentCustomDimension3
            self.contentCustomDimension4 = contentCustomDimension4
            self.contentCustomDimension5 = contentCustomDimension5
            self.contentCustomDimension6 = contentCustomDimension6
            self.contentCustomDimension7 = contentCustomDimension7
            self.contentCustomDimension8 = contentCustomDimension8
            self.contentCustomDimension9 = contentCustomDimension9
            self.contentCustomDimension10 = contentCustomDimension10
            self.contentCustomDimension11 = contentCustomDimension11
            self.contentCustomDimension13 = contentCustomDimension13
        }
    }
    
    let youboraData: YouboraData?
    
    public init(youboraData: YouboraData?) {
        self.youboraData = youboraData
    }
}


