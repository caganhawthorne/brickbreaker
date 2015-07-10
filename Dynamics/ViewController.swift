//
//  ViewController.swift
//  Dynamics
//
//  Created by caganhawthorne on 7/9/15.
//  Copyright © 2015 Cagan Hawthorne. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    var paddle = UIView()
    var ball = UIView()
    var lives = 5
    var bricks : [Brick] = []
    var bricksDestroyed = 0

    
    
    @IBOutlet weak var livesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGame()

    }
    

    
    func setUpGame() {
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 20, 20))
        ball.backgroundColor = UIColor.purpleColor()
        ball.layer.cornerRadius = 10
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        
        paddle = UIView(frame: CGRectMake(view.center.x, view.center.y * 1.7, 80, 20))
        paddle.backgroundColor = UIColor.redColor()
        paddle.layer.cornerRadius = 10
        paddle.clipsToBounds = true
        
        view.addSubview(paddle)
        
        for i in 0...7 {
            let x = CGFloat(10+45*i)
            let brick = Brick(color: .blueColor(), x: x, y: CGFloat(20))
            view.addSubview(brick)
            bricks.append(brick)
        }
        for i in 0...7 {
            let x = CGFloat(10+45*i)
            let brick = Brick(color: .orangeColor(), x: x, y: CGFloat(50))
            view.addSubview(brick)
            bricks.append(brick)
        }
        for i in 0...7 {
            let x = CGFloat(10+45*i)
            let brick = Brick(color: .orangeColor(), x: x, y: CGFloat(80))
            view.addSubview(brick)
            bricks.append(brick)
        }
        for i in 0...7 {
            let x = CGFloat(10+45*i)
            let brick = Brick(color: .orangeColor(), x: x, y: CGFloat(110))
            view.addSubview(brick)
            bricks.append(brick)
        }
        for i in 0...7 {
            let x = CGFloat(10+45*i)
            let brick = Brick(color: .greenColor(), x: x, y: CGFloat(140))
            view.addSubview(brick)
            bricks.append(brick)
        }
        for i in 0...7 {
            let x = CGFloat(10+45*i)
            let brick = Brick(color: .greenColor(), x: x, y: CGFloat(170))
            view.addSubview(brick)
            bricks.append(brick)
        }
        


        
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.allowsRotation  = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        let paddleDynamicBehaviour = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehaviour.density = 10000
        paddleDynamicBehaviour.resistance = 100
        paddleDynamicBehaviour.allowsRotation = false
        
        
        dynamicAnimator.addBehavior(paddleDynamicBehaviour)
        
        
        let brickDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(brickDynamicBehavior)
        
        
        let pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.2, 1.0)
        pushBehavior.magnitude = 0.25
        
        dynamicAnimator.addBehavior(pushBehavior)
        var items : [UIView] = bricks
        items.append(paddle)
        items.append(ball)
        
        collisionBehavior = UICollisionBehavior(items: items)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        livesLabel.text = "Lives: \(lives)"
        

        
    }
    
    

    @IBAction func paddleDragged(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center = CGPointMake(panGesture.x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y {
            lives--
            if lives>0 {
                
                livesLabel.text = "Lives: \(lives)"
                sleep(1)
                ball.center = view.center
                dynamicAnimator.updateItemUsingCurrentState(ball)

            }
            else {
                livesLabel.text = "Game Over"
                collisionBehavior.removeItem(ball)
                ball.removeFromSuperview()
                alertMessage("Game Over")

            }
        }
    }
    
    
  
    
    
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
    
            for i in 0..<bricks.count {
            
            if item1.isEqual(bricks[i]) && item2.isEqual(ball) {
                if (bricks[i].backgroundColor == .blueColor()) {
                    bricks[i].backgroundColor = UIColor.orangeColor()

                }
                else if (bricks[i].backgroundColor == .orangeColor()) {
                    bricks[i].backgroundColor = UIColor.greenColor()
                }
                else {
                    bricks[i].hidden = true
                    collisionBehavior.removeItem(item1)
                    bricksDestroyed++
   
                }
            
                
            }
            else if item2.isEqual(bricks[i]) && item1.isEqual(ball) {
                if (bricks[i].backgroundColor == .blueColor()) {
                    bricks[i].backgroundColor = UIColor.orangeColor()
                    
                }
                else if (bricks[i].backgroundColor == .orangeColor()) {
                    bricks[i].backgroundColor = UIColor.greenColor()
                }
                else {
                    bricks[i].hidden = true
                    bricksDestroyed++
                    collisionBehavior.removeItem(item2)
                    
                }
                
            }
                if checkIfGameIsWon() {
                    alertMessage("You Win")
                }
        
        
    }
    }
    
    func checkIfGameIsWon() -> Bool {
        if bricksDestroyed==48 {
            livesLabel.text = "You Win!"
            ball.removeFromSuperview()
            collisionBehavior.removeItem(ball)
            dynamicAnimator.updateItemUsingCurrentState(ball)

            return true
        }
        return false
    }
    
    func reset() {
        
        
        print("reset")
        
        bricksDestroyed = 0
        for i in bricks {
            i.hidden = true
            i.removeFromSuperview()
        }
        bricks.removeAll()
        paddle.removeFromSuperview()
        collisionBehavior.removeItem(paddle)
        
        lives = 5

        setUpGame()
        
    }
    
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: message, message: "Play Again?", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Play Again", style: .Default) { (action) -> Void in
            self.reset()
        }
        
        let quitAction = UIAlertAction(title: "Quit", style: .Cancel) { (action) -> Void in
            self.performSegueWithIdentifier("quit", sender: nil)
        }
        
        
        alert.addAction(action)
        alert.addAction(quitAction)

        
        self.presentViewController(alert, animated: true, completion: nil)

        
    }

    
}






