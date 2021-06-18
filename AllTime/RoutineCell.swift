//
//  RoutineCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/10/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit
import BAFluidView

class RoutineCell: UITableViewCell {
    
    @IBOutlet weak var routineView: UIView!
    @IBOutlet weak var fluidView: BAFluidView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numCompleted: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var goalNumLabel: UILabel!
    
    @IBOutlet weak var trashCanImage: UIImageView!
    @IBOutlet weak var wobbleView: WobbleView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var baseView: UIView!
    
    var isInMotion = false
    
    var isScrollEnabled = true
    
    var isIconOpen = false
    
    var dampFactor:CGFloat = 40
    
    //delegate for category cell for button pressed
    var delegate: CategoryCellDelegate?
    
    var generator: UIImpactFeedbackGenerator? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //pan gesture with wobble view
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.handlePan(_:))))
        panGesture.delegate = self
        wobbleView.edges = .Left
        self.routineView.addGestureRecognizer(panGesture)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deletePressed(tag: routineView.tag)
    }
    
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: self.contentView)
        //translate and move unless it goes too right
        if (panGesture.state == .began || panGesture.state == .changed) && (velocity.x/dampFactor + baseView.frame.origin.x >= -150) && (velocity.x/dampFactor + baseView.frame.origin.x <= 0){
            baseView.frame.origin = CGPoint(x: baseView.frame.origin.x + velocity.x/dampFactor,y: 0)
            wobbleView.frame.origin = CGPoint(x: wobbleView.frame.origin.x + velocity.x/dampFactor,y: 0)
            trashCanImage.frame.origin = CGPoint(x: trashCanImage.frame.origin.x + velocity.x/dampFactor,y: trashCanImage.frame.origin.y)
        }
        else if panGesture.state == .ended{
            //if over shot - reeset or if undershot - brought back to normal
            
            //only for iphone XR
            if baseView.frame.origin.x + velocity.x/dampFactor <= -(wobbleView.frame.size.width - 10){
                generator = UIImpactFeedbackGenerator(style: .rigid)
                generator?.prepare()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.generator?.impactOccurred()
                    self.generator = nil
                }
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    self.baseView.frame.origin = CGPoint(x:  -self.wobbleView.frame.size.width, y: 0)
                    self.wobbleView.frame.origin = CGPoint(x: self.routineView.frame.size.width - self.wobbleView.frame.size.width, y: 0)
                    self.trashCanImage.frame.origin = CGPoint(x: self.routineView.frame.size.width - self.wobbleView.frame.size.width + self.wobbleView.frame.size.width/2 - self.trashCanImage.frame.size.width/2, y: self.trashCanImage.frame.origin.y)
                }, completion: nil)
                isIconOpen = true
            }
            else{
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    self.baseView.frame.origin = CGPoint(x:  0, y: 0)
                    self.wobbleView.frame.origin = CGPoint(x: self.routineView.frame.size.width, y: 0)
                    self.trashCanImage.frame.origin = CGPoint(x: self.routineView.frame.size.width + self.wobbleView.frame.size.width/2 - self.trashCanImage.frame.size.width/2, y: self.trashCanImage.frame.origin.y)
                }, completion: nil)
                isIconOpen = false
            }
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
