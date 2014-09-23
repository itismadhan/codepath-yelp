//
//  dispatch.swift
//  rotten
//
//  Created by Madhan Padmanabhan on 9/15/14.
//  Copyright (c) 2014 Madhan. All rights reserved.
//

import Foundation

class dispatch
{
    class async
    {
        class func bg(block: dispatch_block_t) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
        }
        
        class func main(block: dispatch_block_t) {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    }
}