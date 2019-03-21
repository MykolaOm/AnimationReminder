//
//  ViewController.swift
//  Animation
//
//  Created by Mykola Omelianov on 3/21/19.
//  Copyright © 2019 Mykola Omelianov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var leftLabel = UILabel()
    private var rightLabel = UILabel()
    private var startButton = UIButton()
    private var centerL = CGPoint()
    private var centerR = CGPoint()
    private var readyToAnimate = true
    private let distance = 500
    lazy var screenWidth: CGFloat = { [unowned self] in
        return self.view.frame.width
    }()
    private lazy var screenHeight = { [unowned self] in
        return self.view.frame.height
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftX = Int(screenWidth)/4
        let rightX = Int(screenWidth) * 3 / 4
        let initialY = Int(screenHeight) / 6
        let btnPoint = CGPoint(x: 0, y: 0)
        let pointL = CGPoint(x: leftX-50, y: initialY)
        let pointR = CGPoint(x: rightX-100, y: initialY)
        let size = CGSize(width: 150, height: 30)
        let bRect = CGRect(origin: btnPoint, size: size)
        let lRect = CGRect(origin: pointL, size: size)
        let rRect = CGRect(origin: pointR, size: size)
        
        leftLabel = setLabel(frame: lRect, bgColor: .red, text: "Spring")
        centerL = leftLabel.center
        rightLabel = setLabel(frame: rRect, bgColor: .green, text: "Move")
        centerR = rightLabel.center
        startButton = setButton(frame: bRect, bgColor: UIColor.yellow , text: "Start")
    }

    private func setLabel(frame: CGRect,bgColor: UIColor, text : String) -> UILabel {
        let view = UILabel(frame: frame)
        view.text = text
        view.backgroundColor = bgColor
        view.textAlignment = .center
        self.view.addSubview(view)
        return view
    }
    private func setButton(frame: CGRect,bgColor: UIColor, text : String) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(text, for: .normal)
        button.tintColor = .black
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = bgColor
        button.center.x = self.view.center.x
        button.center.y = screenHeight - 200
        button.addTarget(self, action: #selector(animateTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    @objc private func animateTapped() {
        if readyToAnimate {
            onStartAnimation(view: self.leftLabel, distance: CGFloat(self.distance), completion: backWardAnimation() )
            onStartAnimation(view: self.rightLabel, distance: -1000, completion: {}())
        } else {
            leftLabel.center = centerL
            rightLabel.center = centerR
        }
        if readyToAnimate {
            self.startButton.setTitle("Reset", for: .normal)
            readyToAnimate = false
        } else {
            self.startButton.setTitle("Start", for: .normal)
            readyToAnimate = true
        }
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
}

