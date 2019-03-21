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
    private var centerB = CGPoint()
    private var readyToAnimate = true
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
        updateSavedPositions()
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
    
   private func backWardAnimation() {
        UIView.animate(withDuration: 2, delay: 0,
                       options: [.curveEaseOut],
                       animations: {
                        self.animateConstraint(view: self.leftLabel, value: 150)
                        self.view.layoutSubviews()
        },
                       completion: nil )
    }
    func onStartAnimation(view: UIView,completion: (), option: UIView.AnimationOptions) {
        UIView.animate(withDuration: 2, delay: 0,
                       options: [option],
                       animations: {
                        self.animateConstraint(view: self.leftLabel, value: 4.0)
                        self.animateConstraint(view: self.rightLabel, value: -10.0)
                        self.view.layoutSubviews()
        },
                       completion: { (finish : Bool) in
                        completion }
        )
    }
    func stopAnimation() {
        resetConstraints(view: leftLabel)
        resetConstraints(view: rightLabel)
        self.view.layoutSubviews()
    }
    func updateSavedPositions(){
        centerL = leftLabel.center
        centerR = rightLabel.center
        centerB = startButton.center
    }

    func runAnimationBlock() {
//        onStartAnimation(view: self.leftLabel, completion: backWardAnimation() ,option: UIView.AnimationOptions.curveEaseOut)
        onStartAnimation(view: self.leftLabel, completion: {}() ,option: UIView.AnimationOptions.curveEaseOut)
        onStartAnimation(view: self.rightLabel, completion: {}(), option: UIView.AnimationOptions.curveLinear)
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
            view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20*self.multiplier).isActive = true
            if isLeft {
                view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30*self.multiplier).isActive = true
            } else {
                view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30*self.multiplier).isActive = true
            }
        } else {
            view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30*self.multiplier).isActive = true
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        }
    }
    func animateConstraint(view: UIView, value:CGFloat) {
        let margins = self.view.layoutMarginsGuide
//        NSLayoutConstraint.deactivate([margins.topAnchor])
//        NSLayoutConstraint.activate([margins.bottomAnchor])
         view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20 * self.multiplier * value).isActive = true
    }
    func resetConstraints(view : UIView){
       let margins = self.view.layoutMarginsGuide
       view.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20 * self.multiplier).isActive = true
    }
}

