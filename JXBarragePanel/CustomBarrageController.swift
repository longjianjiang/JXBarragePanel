//
//  CustomBarrageController.swift
//  JXBarragePanel
//
//  Created by zl on 2018/9/26.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

import UIKit

struct CustomBarrageNode: JXBarrageNodeProtocol {
    func getBarrageNodeWidth() -> CGFloat {
        return str.widthWithFont(font: UIFont.systemFont(ofSize: 15)) + 36
    }
    func getBarrageNode() -> UIView {
        let node = CustomBarrage.init(str: str)
        return node
    }
    
    let str: String!
    let avatar: String!
    init(avatar: String, str: String) {
        self.str = str
        self.avatar = avatar
    }
    
}

class CustomBarrage: UIView {
    let label = UILabel()
    let avatar = UIImageView()
    
    init(str: String) {
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = .red
        avatar.layer.cornerRadius = 10.0
        avatar.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.red
        label.text = str
        
        addSubview(avatar)
        addSubview(label)
        
        let avatarConstraints = [avatar.centerYAnchor.constraint(equalTo: centerYAnchor),
                                 avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
                                 avatar.widthAnchor.constraint(equalToConstant: 20),
                                 avatar.heightAnchor.constraint(equalToConstant: 20)]
        
        let labelConstraints = [label.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 4),
                                label.centerYAnchor.constraint(equalTo: centerYAnchor)]
        
        NSLayoutConstraint.activate(avatarConstraints + labelConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CustomBarrageController: UIViewController {

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

extension CustomBarrageController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let node = CustomBarrageNode.init(avatar: "avatar", str: text)
            barragePanel.add(barrage: node)
        }
        
        return true
    }
}
