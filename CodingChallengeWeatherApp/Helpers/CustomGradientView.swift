//
//  CustomGradientView.swift
//  CodingChallengeWeatherApp
//
//  Created by Fahad Saleem on 8/29/24.
//

import Foundation
import UIKit

@IBDesignable
class Gradient: UIView{

    //MARK: - Gradient
    //Make as many colors as you want to appear in your gradient
    @IBInspectable var firstColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = false{
        didSet{
            updateView()
        }
    }
    
    //Override the layerClass as its set to CALayer by default to CAGradientLayer to make it work
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    //Main function handling the gradient appearance
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        
        if (isHorizontal){
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
}
