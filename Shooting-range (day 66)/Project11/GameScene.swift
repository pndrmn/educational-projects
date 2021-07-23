//
//  GameScene.swift
//  Project11
//
//  Created by Roman Gorodilov on 22.05.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameTimerTopRow: Timer?
    var gameTimerMiddleRow: Timer?
    var gameTimerBottomRow: Timer?
    var gameTimer: Timer?
    
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletLabel: SKLabelNode!

    var bullet = 6 {
        didSet {
            bulletLabel.text = "\(bullet)"
        }
    }
    
    var gameTime = 30 {
        didSet {
            gameTimeLabel.text = "Time: \(gameTime)"
            if gameTime == 0 {
                gameOver()
            }
        }
    }
    
    var gameTimeLabel: SKLabelNode!
    var gameOverLabel: SKSpriteNode!
    var newGameLabel: SKLabelNode!
    var bulletImage: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        startGame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if gameOverLabel == nil {
                
                if bullet > 0 {
                    
                    bullet -= 1
                    run(SKAction.playSoundFileNamed("gunsound.mp3", waitForCompletion: false))
                    
                    for object in objects {
                        
                        if object.name == "good" {
                            score -= 3
                            run(SKAction.playSoundFileNamed("Quack.mp3", waitForCompletion: false))
                        } else if object.name == "targetSmall" {
                            score += 2

                        } else if object.name == "targetBig" {
                            score += 1
                        }
                        
                        if object is Target {
                            let explosion = SKEmitterNode(fileNamed: "explosion")!
                            explosion.position = location
                            explosion.zPosition = 1
                            addChild(explosion)
                            object.removeFromParent()
                        }
                    }
                    
                } else {
                    if objects.contains(bulletImage) {
                        bullet = 6
                        run(SKAction.playSoundFileNamed("reload.mp3", waitForCompletion: false))
                    }
                }
            } else {
                if newGameLabel != nil {
                    if objects.contains(newGameLabel) {
                        newGame()
                    }
                }
            }
        }
    }
    
    func startGame() {
        
        var xCurtane = 128
        var xWater1 = 110
        var xWater2 = 35
        var xGrass1 = 100
        var xGrass2 = 232
        var xBackground = 256
        
        for _ in 0...1 {
            let background = SKSpriteNode(imageNamed: "bg_wood.png")
            background.position = CGPoint(x: xBackground, y: 500)
            background.blendMode = .replace
            background.zPosition = -1
            background.xScale = 2
            background.yScale = 2
            addChild(background)
            xBackground += 512
        }
        
        for _ in 0...3 {
            
            let curtain = SKSpriteNode(imageNamed: "curtain_straight.png")
            curtain.position = CGPoint(x: xCurtane, y: 728)
            curtain.zPosition = 0.95
            addChild(curtain)
            xCurtane += 256
        }
        
        for _ in 0...6 {
            
            let water1 = SKSpriteNode(imageNamed: "water1.png")
            water1.position = CGPoint(x: xWater1, y: 110)
            water1.zPosition = 0.45
            addChild(water1)
            xWater1 += 132
        }
        
        for _ in 0...7 {
            
            let water2 = SKSpriteNode(imageNamed: "water2.png")
            water2.position = CGPoint(x: xWater2, y: 140)
            water2.zPosition = 0.39
            addChild(water2)
            xWater2 += 132
        }
        
        for _ in 0...3 {
            
            let gras1 = SKSpriteNode(imageNamed: "grass2.png")
            gras1.position = CGPoint(x: xGrass1, y: 250)
            gras1.zPosition = 0.1
            addChild(gras1)
            xGrass1 += 264
        }
        
        for _ in 0...2 {
            
            let gras2 = SKSpriteNode(imageNamed: "grass1.png")
            gras2.position = CGPoint(x: xGrass2, y: 242)
            gras2.zPosition = 0.1
            addChild(gras2)
            xGrass2 += 264
        }
        
        let pine = SKSpriteNode(imageNamed: "tree_pine.png")
        pine.position = CGPoint(x: 900, y: 350)
        pine.zPosition = 0.38
        pine.xScale = 1.5
        pine.yScale = 1.5
        addChild(pine)
        
        let oak = SKSpriteNode(imageNamed: "tree_oak.png")
        oak.position = CGPoint(x: 120, y: 450)
        oak.zPosition = 0
        oak.xScale = 1.1
        oak.yScale = 1.1
        addChild(oak)
            
        let curtainTop = SKSpriteNode(imageNamed: "curtain_top.png")
        curtainTop.position = CGPoint(x: 512, y: 670)
        curtainTop.zPosition = 0.8
        curtainTop.xScale = 2
        addChild(curtainTop)
        
        let curtainTopLeft = SKSpriteNode(imageNamed: "curtain_top.png")
        curtainTopLeft.position = CGPoint(x: 230, y: 690)
        curtainTopLeft.zPosition = 0.6
        curtainTopLeft.xScale = 1.5
        addChild(curtainTopLeft)
        
        let curtainTopRight = SKSpriteNode(imageNamed: "curtain_top.png")
        curtainTopRight.position = CGPoint(x: 794, y: 690)
        curtainTopRight.zPosition = 0.6
        curtainTopRight.xScale = 1.5
        addChild(curtainTopRight)
        
        let curtaneLeft = SKSpriteNode(imageNamed: "curtain left.png")
        curtaneLeft.position = CGPoint(x: 80, y: 500)
        curtaneLeft.zPosition = 0.7
        curtaneLeft.xScale = 1.3
        curtaneLeft.yScale = 2.2
        addChild(curtaneLeft)
        
        let ropeLeft = SKSpriteNode(imageNamed: "curtain_rope.png")
        ropeLeft.position = CGPoint(x: 10, y: 500)
        ropeLeft.zPosition = 0.8
        addChild(ropeLeft)
        
        let curtaneRight = SKSpriteNode(imageNamed: "curtain right.png")
        curtaneRight.position = CGPoint(x: 944, y: 500)
        curtaneRight.zPosition = 0.7
        curtaneRight.xScale = 1.3
        curtaneRight.yScale = 2.2
        addChild(curtaneRight)
        
        let ropeRight = SKSpriteNode(imageNamed: "curtain_rope.png")
        ropeRight.position = CGPoint(x: 1014, y: 500)
        ropeRight.zPosition = 0.8
        addChild(ropeRight)
        
        let cloud1 = SKSpriteNode(imageNamed: "cloud1")
        cloud1.position = CGPoint(x: 800, y: 640)
        cloud1.zPosition = 0.3
        cloud1.xScale = 1.5
        cloud1.yScale = 1.5
        addChild(cloud1)
        
        let cloud2 = SKSpriteNode(imageNamed: "cloud2")
        cloud2.position = CGPoint(x: 200, y: 640)
        cloud2.zPosition = 0.3
        cloud2.xScale = 1.5
        cloud2.yScale = 1.5
        addChild(cloud2)
        
        let desk = SKSpriteNode(imageNamed: "desk")
        desk.position = CGPoint(x: 512, y: 70)
        desk.zPosition = 0.6
        desk.xScale = 2.5
        desk.yScale = 0.6
        addChild(desk)
        
        bulletImage = SKSpriteNode(imageNamed: "bullet.png")
        bulletImage.position = CGPoint(x: 830, y: 75)
        bulletImage.zPosition = 1
        bulletImage.xScale = 2
        bulletImage.yScale = 2
        addChild(bulletImage)
        
        let rifle = SKSpriteNode(imageNamed: "rifle.png")
        rifle.position = CGPoint(x: 650, y: 75)
        rifle.zPosition = 1
        rifle.xScale = 0.7
        rifle.yScale = 0.7
        addChild(rifle)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 100, y: 50)
        scoreLabel.xScale = 2.2
        scoreLabel.yScale = 2.2
        scoreLabel.zPosition = 1
        addChild(scoreLabel)

        bulletLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletLabel.text = "6"
        bulletLabel.horizontalAlignmentMode = .right
        bulletLabel.position = CGPoint(x: 920, y: 50)
        bulletLabel.xScale = 2.2
        bulletLabel.yScale = 2.2
        bulletLabel.zPosition = 1
        addChild(bulletLabel)
        
        gameTimeLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameTimeLabel.text = "Time: 30"
        gameTimeLabel.horizontalAlignmentMode = .right
        gameTimeLabel.position = CGPoint(x: 1000, y: 715)
        gameTimeLabel.xScale = 1.5
        gameTimeLabel.yScale = 1.5
        gameTimeLabel.zPosition = 1
        addChild(gameTimeLabel)
        
        gameTimerTopRow = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(createTargetTopRow), userInfo: nil, repeats: true)
        gameTimerMiddleRow = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTargetMiddleRow), userInfo: nil, repeats: true)
        gameTimerBottomRow = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createTargetBottomRow), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in self?.gameTime -= 1}
    }
    
    func newGame() {
        removeAllChildren()
        startGame()
        score = 0
        bullet = 6
        gameTime = 30
        gameOverLabel = nil
        newGameLabel = nil
    }
    
    func gameOver() {
        gameTimerTopRow?.invalidate()
        gameTimerMiddleRow?.invalidate()
        gameTimerBottomRow?.invalidate()
        gameTimer?.invalidate()
        
        gameOverLabel = SKSpriteNode(imageNamed: "text_gameover.png")
        gameOverLabel.position = CGPoint(x: 512, y: 500)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "Start new game"
        newGameLabel.position = CGPoint(x: 512, y: 375)
        newGameLabel.zPosition = 1
        newGameLabel.horizontalAlignmentMode = .center
        newGameLabel.fontSize = 60
        newGameLabel.fontColor = .white
        addChild(newGameLabel)
        
        run(SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false))
    }
    
    @objc func createTargetTopRow (at position: CGPoint) {
        let target = Target()
        target.configure(at: CGPoint(x: 0, y: 600))
        addChild(target)
    }
    
    @objc func createTargetMiddleRow (at position: CGPoint) {
        let target = Target()
        target.configureRightToLeft(at: CGPoint(x: 1024, y: 425))
        addChild(target)
    }
    
    @objc func createTargetBottomRow (at position: CGPoint) {
        let target = Target()
        target.configure(at: CGPoint(x: 0, y: 250))
        addChild(target)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -100 || node.position.x > 1100 {
                node.removeFromParent()
            }
        }
    }
}
