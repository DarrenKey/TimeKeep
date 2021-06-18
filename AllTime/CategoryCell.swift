//
//  CategoryCell.swift
//  TimeKeep
//
//  Created by Mi Yan on 4/11/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate{
    func deletePressed(tag: Int)
    func stopScroll()
    func startScroll()
}

class CategoryCell: UITableViewCell {

    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var wobbleView: WobbleView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var trashCanIcon: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //delegate for category cell for button pressed
    var delegate: CategoryCellDelegate?
    
    var generator: UIImpactFeedbackGenerator? = nil
    
    var isInMotion = false
    
    var isScrollEnabled = true
    
    var isIconOpen = false
    
    var dampFactor:CGFloat = 40
    
    //resize
    var screenHeight: CGFloat = 0
    var screenWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //pan gesture with wobble view
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(self.handlePan(_:))))
        panGesture.delegate = self
        wobbleView.edges = .Left
        self.contentView.addGestureRecognizer(panGesture)
        
        //initialize screenheight and width
        let screen = UIScreen.main.bounds
        screenWidth = screen.size.width
        screenHeight = screen.size.height
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deletePressed(tag: self.tag)
    }
    
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: self.contentView)
        if (panGesture.state == .began || panGesture.state == .changed) && (velocity.x/dampFactor + mainView.frame.origin.x >= -150) && (velocity.x/dampFactor + mainView.frame.origin.x <= 0){
            mainView.frame.origin = CGPoint(x: mainView.frame.origin.x + velocity.x/dampFactor,y: 0)
            wobbleView.frame.origin = CGPoint(x: wobbleView.frame.origin.x + velocity.x/dampFactor,y: 0)
            trashCanIcon.frame.origin = CGPoint(x: trashCanIcon.frame.origin.x + velocity.x/dampFactor,y: trashCanIcon.frame.origin.y)
        }
        else if panGesture.state == .ended{
            //if over shot - reeset or if undershot - brought back to normal
            
            //only for iphone XR
            if mainView.frame.origin.x + velocity.x/dampFactor <= -(wobbleView.frame.size.width - 10){
                generator = UIImpactFeedbackGenerator(style: .rigid)
                generator?.prepare()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.generator?.impactOccurred()
                    self.generator = nil
                }
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    self.mainView.frame.origin = CGPoint(x: -self.wobbleView.frame.size.width, y: 0)
                    self.wobbleView.frame.origin = CGPoint(x: self.screenWidth - self.wobbleView.frame.size.width, y: 0)
                    self.trashCanIcon.frame.origin = CGPoint(x: self.screenWidth - self.wobbleView.frame.size.width + self.wobbleView.frame.size.width/2 - self.trashCanIcon.frame.size.width/2, y: self.trashCanIcon.frame.origin.y)
                }, completion: nil)
                isIconOpen = true
            }
            else{
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    self.mainView.frame.origin = CGPoint(x:  0, y: 0)
                    self.wobbleView.frame.origin = CGPoint(x: self.screenWidth, y: 0)
                    self.trashCanIcon.frame.origin = CGPoint(x: self.screenWidth + self.wobbleView.frame.size.width/2 - self.trashCanIcon.frame.size.width/2, y: self.trashCanIcon.frame.origin.y)
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
