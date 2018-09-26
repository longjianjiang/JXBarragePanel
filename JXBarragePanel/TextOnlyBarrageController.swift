//
//  TextOnlyBarrageController.swift
//  JXBarragePanel
//
//  Created by zl on 2018/9/25.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

import UIKit

struct TextBarrageNode: JXBarrageNodeProtocol {
    func getBarrageNodeWidth() -> CGFloat {
        return str.widthWithFont(font: UIFont.systemFont(ofSize: 15))
    }
    func getBarrageNode() -> UIView {
        let label = UILabel()
        label.text = str
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.red
        return label
    }
    
    let str: String!
    init(barrageNode str: String) {
        self.str = str
    }
}


class TextOnlyBarrageController: UIViewController {
    
    var barragePanel: JXBarragePanel!
    var textField: UITextField!
    
    func setupBarragePanel() {
        barragePanel = JXBarragePanel.init(panelSize: CGSize(width: 414, height: 200), barrageHeight: 30, barrageLineSpace: 10)
        barragePanel.frame = CGRect(x: 0,
                                    y: 100,
                                    width: view.frame.size.width,
                                    height: 200)
        barragePanel.backgroundColor = UIColor.orange
        view.addSubview(barragePanel)
        
        textField = UITextField(frame: CGRect(x: 10,
                                              y: 450,
                                              width: view.frame.size.width-20,
                                              height: 44))
        textField.borderStyle = .roundedRect
        textField.delegate = self
        view.addSubview(textField)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupBarragePanel()
    }
}

extension TextOnlyBarrageController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let node = TextBarrageNode.init(barrageNode: text)
            barragePanel.add(barrage: node)
        }
        
        return true
    }
}


extension String {
    func widthWithFont(font : UIFont = UIFont.systemFont(ofSize: 15)) -> CGFloat {
        guard isEmpty == false else {
            return 0
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.width
    }
}

