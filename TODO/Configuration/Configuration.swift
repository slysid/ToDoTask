//
//  Configuration.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import Foundation
import UIKit

let DATAFILENAME = "data.json"
let CELLHEIGHT:CGFloat = 100
let MAXTAGS = 3
var EDITBUTTONS = [["title":"EDIT","selector":"editAction"],
                   ["title":"CANCEL","selector":"cancelAction"],
                   ["title":"COMPLETE","selector":"completeAction"]
]

let EDIT = NSLocalizedString("LOC_EDIT", comment: "")
let ADD = NSLocalizedString("LOC_ADD", comment: "")
let COMMIT = NSLocalizedString("LOC_COMMIT", comment: "")
