//
//  Timeline.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/9/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import UIKit

class Timeline: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    var labelArrayBig: [UILabel] = []
    var seperatorArrayBig: [UIImageView] = []
    
    //label of seperatorcell
    var timeArray: [String] = ["12","1","2","3","4","5","6","7","8","9","10","11"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        
        setOverlay()
    }
    
    func setOverlay(){
        
        let viewDivision: CGFloat = (contentView.frame.size.height - 25 * 26)/25
        for i in 0...24{
            
            //only for XR
            labelArrayBig.append(UILabel(frame: CGRect(x: 0, y: viewDivision * CGFloat(i) + 26 * CGFloat(i), width: 59, height: 26)))
            labelArrayBig[i].textAlignment = .right
            labelArrayBig[i].text = "\(timeArray[i % 12]):00"
            labelArrayBig[i].font = UIFont(name: "Futura", size: 20)
            labelArrayBig[i].textColor = UIColor(hex: "E85A4F")
            
            contentView.addSubview(labelArrayBig[i])
            
            //only for XR
            seperatorArrayBig.append(UIImageView(image: UIImage(named: "DottedLine")))
            seperatorArrayBig[i].frame = CGRect(x: 63, y: viewDivision * CGFloat(i) + 26 * CGFloat(i), width: 351, height: 26)
            seperatorArrayBig[i].contentMode = .center
            
            contentView.addSubview(seperatorArrayBig[i])
        }
        
        
    }

}

extension Timeline: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(contentView.frame)
    }
}
