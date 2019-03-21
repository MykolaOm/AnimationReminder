//
//  ViewController.swift
//  Animation
//
//  Created by Mykola Omelianov on 3/21/19.
//  Copyright © 2019 Mykola Omelianov. All rights reserved.
//

import UIKit
typealias tupleVar = (CGRect,CGRect,CGRect)
class ViewController: UIViewController {

    private var leftLabel = UILabel()
    private var rightLabel = UILabel()
    private var startButton = UIButton()
    private var centerL = CGPoint()
    private var centerR = CGPoint()
    private var centerB = CGPoint()
    private var readyToAnimate = true
    private let distance = 500
    lazy var screenWidth: CGFloat = { [unowned self] in
        return self.view.frame.width
    }()
    private lazy var screenHeight = { [unowned self] in
        return self.view.frame.height
    }()
    private lazy var multiplier = {[unowned self] in
        // compare to Xr 896.0
        return (self.view.frame.height/896.0 )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sizes = setSizes()
        leftLabel = setLabel(frame: sizes.0, bgColor: .red, text: "Spring")
        rightLabel = setLabel(frame: sizes.1, bgColor: .green, text: "Move")
        startButton = setButton(frame: sizes.2, bgColor: UIColor.yellow , text: "Start")
        updateSavedPositions()
    }
    private func setLabel(frame: CGRect,bgColor: UIColor, text : String) -> UILabel {
        let view = UILabel(frame: frame)
        view.text = text
        view.backgroundColor = bgColor
        view.textAlignment = .center
        self.view.addSubview(view)
        return view
    }
    private func setButton(frame: CGRect, bgColor: UIColor, text : String) -> UIButton {

        let button = UIButton(frame: frame)
        button.setTitle(text, for: .normal)
        button.tintColor = .black
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = bgColor
        button.center.x = self.view.center.x
        button.center.y = screenHeight - 200*multiplier
        button.addTarget(self, action: #selector(animateTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    @objc private func animateTapped() {

        if readyToAnimate {
            onStartAnimation(view: self.leftLabel, distance: CGFloat(self.distance)*multiplier, completion: backWardAnimation() )
            onStartAnimation(view: self.rightLabel, distance: -1000*multiplier, completion: {}())
        } else {
            stopAnimation()
        }
        let txt = readyToAnimate ? "Reset": "Start"
        self.startButton.setTitle(txt, for: .normal)
        readyToAnimate = readyToAnimate ? false : true
    }
   private func backWardAnimation() {
        UIView.animate(withDuration: 4, delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.leftLabel.center.y -= CGFloat(self.distance/2)
        },
                       completion: nil )
    }
    func onStartAnimation(view: UIView, distance: CGFloat, completion: ()) {
        UIView.animate(withDuration: 2, delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        view.center.y += distance
        },
                       completion: { (finish : Bool) in
                        completion }
        )
    }
    func stopAnimation() {
        self.leftLabel.center = self.centerL
        self.rightLabel.center = self.centerR
    }
    func updateSavedPositions(){
        centerL = leftLabel.center
        centerR = rightLabel.center
        centerB = startButton.center
    }
    func setSizes() -> tupleVar {
        let leftX = screenWidth/4
        let rightX = screenWidth * 3 / 4
        let initialY = screenHeight / 6
        let btnPoint = CGPoint(x: 0, y: 0)
        let pointL = CGPoint(x: leftX-(50.0 * multiplier), y: initialY)
        let pointR = CGPoint(x: rightX-(100.0 * multiplier), y: initialY)
        let size = CGSize(width: 150*multiplier, height: 30*multiplier)
        let bRect = CGRect(origin: btnPoint, size: size)
        let lRect = CGRect(origin: pointL, size: size)
        let rRect = CGRect(origin: pointR, size: size)
        
        return (lLabel: lRect, rLabel: rRect, btn: bRect)
    }
}

