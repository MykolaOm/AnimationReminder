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
    private var readyToAnimate = true
    private var leftLabelCenterYConstraint: NSLayoutConstraint!
    private var leftLabelBottomConstraint: NSLayoutConstraint!
    private var rightLabelCenterYConstraint: NSLayoutConstraint!
    private var startButtonBottomConstraint: NSLayoutConstraint!
    private lazy var multiplier = {[unowned self] in
        // compare to Xr 896.0
        return (self.view.frame.height/896.0 )
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        leftLabel = setLabel(bgColor: .red, text: "Spring")
        rightLabel = setLabel(bgColor: .green, text: "Move")
        startButton = setButton(bgColor: UIColor.yellow , text: "Start")
        runWithConstraints()
    }

    private func setLabel(bgColor: UIColor, text : String) -> UILabel {
        let view = UILabel()
        view.text = text
        view.backgroundColor = bgColor
        view.textAlignment = .center
        self.view.addSubview(view)
        return view
    }
    private func setButton(bgColor: UIColor, text : String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.tintColor = .black
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = bgColor
        button.addTarget(self, action: #selector(animateTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    @objc private func animateTapped() {
        _ = readyToAnimate ? runAnimationBlock() : stopAnimation()
        let txt = readyToAnimate ? "Reset": "Start"
        self.startButton.setTitle(txt, for: .normal)
        readyToAnimate = readyToAnimate ? false : true
    }
   private func completionAnimation() {
    print("backWardAnimation")
    leftLabelCenterYConstraint.isActive = false
    leftLabelBottomConstraint.isActive = true
        UIView.animate(withDuration: 2, delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil )
    }
    private func rightAnimation() {
        print("rightAnimation")
        rightLabelCenterYConstraint.constant = -self.view.center.y
        UIView.animate(withDuration: 2, delay: 0,
                       options: [.curveLinear],
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: { (finish: Bool) in
        })
    }
    func onStartAnimation(view: UIView,completion: (), option: UIView.AnimationOptions) {
        print("start")
        leftLabelCenterYConstraint.isActive = true
        leftLabelBottomConstraint.isActive = false
        leftLabelCenterYConstraint.constant = self.view.bounds.maxY * 3/4
        UIView.animate(withDuration: 2, delay: 2,
                       options: [option],
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: { (finish : Bool) in
                        completion }
        )
    }
    func stopAnimation() {
        resetConstraints()
        self.view.layoutIfNeeded()
    }
    func runAnimationBlock() {
        onStartAnimation(view: self.leftLabel, completion: completionAnimation() ,option: UIView.AnimationOptions.curveEaseOut)
        rightAnimation()
    }
    func runWithConstraints(){
        turnOffAutoresizingMask(to: [leftLabel,rightLabel,startButton])
        setConstrainsToWidthAndHeight(views: [leftLabel,rightLabel,startButton])
        setViewConstrain(view: leftLabel, isLeft: true, isLabel: true)
        setViewConstrain(view: rightLabel, isLeft: false, isLabel: true)
        setViewConstrain(view: startButton, isLeft: false, isLabel: false)
    }
    func turnOffAutoresizingMask(to views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func setConstrainsToWidthAndHeight(views: [UIView]){
        for view in views {
            view.widthAnchor.constraint(equalToConstant: 150*self.multiplier).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30*self.multiplier).isActive = true
        }
    }
    func setViewConstrain(view: UIView, isLeft : Bool, isLabel: Bool) {
       let margins = self.view.layoutMarginsGuide
        if isLabel {
            if isLeft {
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30*self.multiplier).isActive = true
                leftLabelCenterYConstraint = view.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.center.y)
                leftLabelCenterYConstraint.isActive = true
                leftLabelBottomConstraint = view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60*self.multiplier)
                leftLabelBottomConstraint.isActive = false
            } else {
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30*self.multiplier).isActive = true
                rightLabelCenterYConstraint = view.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.center.y)
                rightLabelCenterYConstraint.isActive = true
            }
        } else {
            startButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30*self.multiplier)
            startButtonBottomConstraint.isActive = true
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        }
    }
    func resetConstraints(){
        self.leftLabelCenterYConstraint.isActive = true
        self.leftLabelBottomConstraint.isActive = false
        self.leftLabelCenterYConstraint.constant = self.view.center.y
        self.rightLabelCenterYConstraint.constant = self.view.center.y

    }
}

