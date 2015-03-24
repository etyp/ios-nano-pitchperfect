//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Eric Typaldos on 3/11/15.
//  Copyright (c) 2015 Eric Typaldos. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}