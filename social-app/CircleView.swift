//
//  CircleView.swift
//  social-app
//
//  Created by Nikolai Brix Laursen on 14/03/2017.
//  Copyright © 2017 CrewNET IVS. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        
    }
}
