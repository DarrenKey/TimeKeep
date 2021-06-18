//
//  Task.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/26/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol toPlannerFromTask{
    func deleteCell(location: Int)
    func disablePaging()
    func enablePaging()
    
    func taskDone(location: Int)
    func taskUndone(location: Int)
}

class Task: UITableViewCell {

    @IBOutlet weak var wobbleView: WobbleView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var masterView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var wobbleViewButton: UIButton!
    @IBOutlet weak var trashCanImage: UIImageView!
    
    //check box
    @IBOutlet weak var taskDone: BEMCheckBox!
    
    @IBOutlet weak var checkBoxBackgroundView: UIView!
    //delegate to task
    var delegate: toPlannerFromTask?
    
    //haptic feedback
    var rigidGenerator: UIImpactFeedbackGenerator? = nil
    
    //dampening factor
    var dampFactor:CGFloat = 40
    
    //bool isinmotion
    var isInMotion = false
    
    //bool isPaging
    var isPaging = false
    
    //if trashcanicon is open
    var isOpen = false
    
    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //pan gesture with wobble view
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.handlePan(_:))))
        panGesture.delegate = self
        wobbleView.edges = ViewEdge.Left
        self.contentView.addGestureRecognizer(panGesture)
        
        //resize everything
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
        
        //get checkbox delegate
        taskDone.delegate = self
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteCell(location: self.tag)
    }
    
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: self.contentView)
        //translate and move unless it goes too right
        
        if velocity.x/dampFactor + masterView.frame.origin.x <= 0 && velocity.x/dampFactor + masterView.frame.origin.x >= -150 && isPaging == false && panGesture.state != .began{
            masterView.frame.origin = CGPoint(x: masterView.frame.origin.x + velocity.x/dampFactor,y: 0)
            wobbleView.frame.origin = CGPoint(x: wobbleView.frame.origin.x + velocity.x/dampFactor,y: 0)
            trashCanImage.frame.origin = CGPoint(x: trashCanImage.frame.origin.x + velocity.x/dampFactor,y: trashCanImage.frame.origin.y)
        }
        
        if panGesture.state == .began{
            isInMotion = true
            
            //find acceleration to determine should page or not
            
            print(velocity.x, "velocity x")
            
            //swipe left to right
            if isOpen == true{
                delegate?.disablePaging()
            }
            
            //swipe left to right
            else if velocity.x > -250 && 0 > velocity.x || velocity.x > 0{
                isPaging = true
            }
                
            else{
                delegate?.disablePaging()
            }
        }
        else if panGesture.state == .ended{
            isInMotion = false
            
            //reenable pangesture/paging
            if isPaging == true{
                isPaging = false
            }
            else{
                delegate?.enablePaging()
            }
            
            let newMasterViewLocationX = masterView.frame.origin.x + velocity.x/dampFactor
            print(newMasterViewLocationX)
            
            //if over shot - reeset or if undershot - brought back to normal
            //TRASH CAN
            if newMasterViewLocationX <= -(wobbleView.frame.size.width - 10){
                rigidGenerator = UIImpactFeedbackGenerator(style: .rigid)
                rigidGenerator?.prepare()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.rigidGenerator?.impactOccurred()
                    self.rigidGenerator = nil
                }
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    self.masterView.frame.origin = CGPoint(x:  -self.wobbleView.frame.size.width, y: 0)
                    self.wobbleView.frame.origin = CGPoint(x: self.screenWidth - self.wobbleView.frame.size.width, y: 0)
                    self.trashCanImage.frame.origin = CGPoint(x: self.screenWidth - self.wobbleView.frame.size.width + self.wobbleView.frame.size.width/2 - self.trashCanImage.frame.size.width/2, y: self.trashCanImage.frame.origin.y)
                }, completion: nil)
                isOpen = true
            }
            else if newMasterViewLocationX <= 0{
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    self.masterView.frame.origin = CGPoint(x:  0, y: 0)
                    self.wobbleView.frame.origin = CGPoint(x: self.screenWidth, y: 0)
                    self.trashCanImage.frame.origin = CGPoint(x: self.screenWidth + self.wobbleView.frame.size.width/2 - self.trashCanImage.frame.size.width/2, y: self.trashCanImage.frame.origin.y)
                }, completion: nil)
                isOpen = false
            }
            
            //CHECK BOX
        }
            
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

extension Task: BEMCheckBoxDelegate{
    func didTap(_ checkBox: BEMCheckBox) {
        
        //task done
        if checkBox.on == true{
            delegate?.taskDone(location: self.tag)
        }
            
        //task undone
        else{
            delegate?.taskUndone(location: self.tag)
        }
    }
}
