# JXBarragePanel
One barrage panel that allow you define barrage display style & barrage move animation.

# Usage
you should create a barrage node conform `JXBarrageNodeProtocol`, below is an example:

```swift
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
```

then just call add method:

```swift
let barragePanel = JXBarragePanel.init(panelSize: CGSize(width: 414, height: 200), barrageHeight: 30, barrageLineSpace: 10)
let node = TextBarrageNode.init(barrageNode: text)
barragePanel.add(barrage: node)
```

you also can define your custom animation, let your barrage node confrom `JXBarrageNodeAnimationProtocol`, below is an example:

```swift
    func getBarrageMoveAnimation() -> CAAnimation {
        let animationGroup = CAAnimationGroup()
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: .linear)
        animationGroup.duration = 10
        animationGroup.fillMode = .both
        
        let move = CABasicAnimation.init(keyPath: "position.x")
        move.fromValue = UIScreen.main.bounds.size.width
        move.toValue = -getBarrageNodeWidth()
        let scale = CABasicAnimation.init(keyPath: "transform.scale")
        scale.fromValue = 5
        scale.toValue = 1
        
        animationGroup.animations = [move, scale]
        
        return animationGroup
    }
```

# Contact
brucejiang5.7@gmail.com

# License
MIT