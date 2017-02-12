# FloatingImageViewStack

FloatingImageViewStack is a simple custom control to let you layer floating images on top of eachother. Tap into any image in the stack to select the image and bring it into focus.

[![Simulator Screen Shot Feb 11, 2017, 7.56.07 PM.png](https://s24.postimg.org/ux87n2jad/Simulator_Screen_Shot_Feb_11_2017_7_56_07_PM.png)](https://postimg.org/image/vzie5m23l/)

# How to Use and Setup 

FloatingImageViewStack is `IBDesignable` and many of the properties can be easily changed in the attributes inspect inside of interface builder.

1. Drag a view onto your view controller and subclass it as `FloatingImageViewStack` in interface builder.

  [![Screen Shot 2017-02-11 at 8.06.48 PM.png](https://s27.postimg.org/hxakgdg9v/Screen_Shot_2017_02_11_at_8_06_48_PM.png)](https://postimg.org/image/yl22ivb1b/)

2. Configure any properties via the attribute inspector.

  [![Screen Shot 2017-02-11 at 8.07.01 PM.png](https://s24.postimg.org/6euu9ba2d/Screen_Shot_2017_02_11_at_8_07_01_PM.png)](https://postimg.org/image/di2poxfht/)
  
3. Assign the `FloatingImageViewContainerDelegate` to receive user interactions.

```
class ViewController: UIViewController {    
    @IBOutlet weak var floatingImageStack: FloatingImageViewStack!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        floatingImageStack.delegate = self
    }
 }
 
extension ViewController : FloatingImageViewContainerDelegate {
    func didSelectFloatingTop() {
       
    }
    
    func didSelectFloatingImage(selectedView: FloatingImageView) {
     
    }
}

```







# Live Demonstration

![example_demo](https://cloud.githubusercontent.com/assets/24960143/22858735/f051f308-f093-11e6-914f-1859bd1f4c7f.gif)
