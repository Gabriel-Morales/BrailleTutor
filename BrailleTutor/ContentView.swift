import SwiftUI
import AVFoundation
import MetalKit
import Metal



enum GameState {
    case menu
    case train
}

enum MusicChoice {
    case click
    case correct
    case wrong
}

struct MusicPlayer {
    let audioSession = AVAudioSession.sharedInstance()
    
    let clickPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Clicky", withExtension: "m4a")!)
    let correctPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Correct", withExtension: "wav")!)
    let wrongPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Wrong", withExtension: "wav")!)
    
    private static var mp: MusicPlayer?
    
    init() {
        do {
            try audioSession.setCategory(.ambient)
            try audioSession.setActive(true)
        } catch {
            print("Unable to start session.")
        }
    }
    
    static func getInstance() -> MusicPlayer {
        guard let _mp = mp else {
            mp = MusicPlayer()
            return mp!
        }
        
        return _mp
    }
    
    func playSound(_ choice: MusicChoice) -> Void {
        
        if choice == .click {
            
            clickPlayer.play()
        } else if choice == .correct {
            
            correctPlayer.play()
        } else {
            
            wrongPlayer.play()
        }
    }
    
}



struct ContentView: View {
    
    @State var gameMode: GameState = .menu
    @State var showSettings: Bool = false
    var dummy = MusicPlayer.getInstance()
    @State var showAlp = false
    @State var showHelp = false
    
    @State private var bgColor = Color(.cyan).opacity(0.15)
    @State private var bubbles = Color(.cyan)
    

    @AppStorage("sounds") var sounds = true
    @AppStorage("haptics") var haptics = true
    @AppStorage("colorblind") var colorblind = false
    @AppStorage("cardScale") var scaleCard = false
    @AppStorage("BrailleCard") var cardColor: Array<Double> = [0.0, 0.0, 0.0, 0.0]
    
    
    var body: some View {
        
        
            
            NavigationStack {
                ZStack {
                    
                    if gameMode == .menu {
                        VStack {
                            
                            Text("Braille Buddy")
                                .padding()
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    .purple
                                )
                                .multilineTextAlignment(.center)
                                .accessibilityLabel("Braille Buddy Game Title Bar")
                            
                            
                            
                            
                            Spacer()
                            BrailleAnimWrapper()
                                .accessibilityLabel("Animation of a braille card going through the English Braille Alphabet.")
                                .scaleEffect((UIDevice.current.localizedModel != "iPhone" && scaleCard) ? 2 : 1)
                                
                            Spacer()
                            
                            VStack {
                                
                                Button(action: {
                                    if sounds {
                                        MusicPlayer.getInstance().playSound(.click)
                                    }
                                    gameMode = .train
                                }, label: {
                                    Text("Play")
                                        .foregroundStyle(.white)
                                        .fontWeight(.bold)
                                        .padding()
                                        .frame(width: 250)
                                    
                                })
                                .accessibilityLabel("Play the game")
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 250)
                                        .foregroundStyle(.cyan)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke()
                                        .frame(width: 250)
                                )
                                
                                .padding()
                                
                                
                                Button(action: {
                                    if sounds {
                                        MusicPlayer.getInstance().playSound(.click)
                                    }
                                    showAlp = true
                                    
                                    
                                }, label: {
                                    Text("Alphabet")
                                        .foregroundStyle(.white)
                                        .fontWeight(.bold)
                                        .padding()
                                    
                                    
                                }).background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 250)
                                        .foregroundStyle(.purple)
                                    
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke()
                                        .frame(width: 250)
                                )
                                .padding([.bottom], 25)
                                
                                .sheet(isPresented: $showAlp) {
                                    NavigationStack {
                                        AlphabetView(colorblind: $colorblind)
                                            .toolbar {
                                            ToolbarItem(placement: .navigation) {
                                                Button(action: {
                                                    showAlp = false
                                                }, label: {
                                                    Text("Done")
                                                        .fontWeight(.bold)
                                                })
                                            }
                                        }
                                    }
                                        
                                }
                                
                            }
                            
                            
                            
                        }
                        .ignoresSafeArea(.keyboard)
                    } else if gameMode == .train {
                        GameTrainView(sounds: $sounds, haptics: $haptics, colorblind: $colorblind, upscaleCard: $scaleCard)
                    } else {
                        // stub
                    }
                    
                    
                    
                    
                }
                .ignoresSafeArea(.keyboard)
                .toolbar {
                    
                    if gameMode != .menu {
                        ToolbarItem(placement: .navigation) {
                            Button(action: {
                                gameMode = .menu
                            }, label: {
                                Text("Menu")
                                    .fontWeight(.bold)
                            })
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            showSettings = true
                        }, label: {
                            Image(systemName: "gearshape")
                                .accessibilityLabel("In-app settings")
                        })
                        .sheet(isPresented: $showSettings) {
                            NavigationStack {
                                Form {
                                    Section {
                                       
                                        HStack {
                                            Text("Game Sounds")
                                            Toggle("", isOn: $sounds)
                                        }
                                        if UIDevice.current.localizedModel == "iPhone" {
                                            HStack {
                                                Text("Game Haptics")
                                                Toggle("", isOn: $haptics)
                                            }
                                        }
                                        if UIDevice.current.localizedModel == "iPad" {
                                            HStack {
                                                Text("Upscale Braille Card")
                                                Toggle("", isOn: $scaleCard)
                                                
                                            }
                                        }
                                    } header: {
                                        Text("General")
                                    }
                                    
                                    
                                    Section {
                                        HStack {
                                            Text("Color blindness Mode")
                                            Toggle("", isOn: $colorblind)
                                        }
                                        HStack {
                                            Text("Braille Card Background: ")
                                            if #available(iOS 17.0, *) {
                                                ColorPicker("", selection: $bgColor)
                                                    .onChange(of: bgColor) {
                                                        
                                                    }
                                            } else {
                                                ColorPicker("", selection: $bgColor)
                                                    .onChange(of: bgColor, perform: { value in
                                                        
                                                    })
                                            }
                                                
                                        }
                                        HStack {
                                            Text("Braille Bubbles Selected State: ")
                                            if #available(iOS 17.0, *) {
                                                ColorPicker("", selection: $bubbles)
                                                    .onChange(of: bubbles) {
                                                        
                                                    }
                                            } else {
                                                ColorPicker("", selection: $bubbles)
                                                    .onChange(of: bubbles, perform: { value in
                                                        
                                                    })
                                            }
                                        }
                                        
                                    } header: {
                                        Text("Additional Accessibility")
                                    } footer: {
                                        Text("Color blindness mode enables an extra game cue to help differentiate Braille bubbles (cells) without color.")
                                    }
                                }
                                .toolbar {
                                    ToolbarItem(placement: .navigation) {
                                        Button(action: {
                                            showSettings = false
                                        }, label: {
                                            Text("Done")
                                                .fontWeight(.bold)
                                        })
                                    }
                                }
                            }
                            
                        }
                        .opacity((gameMode == .menu) ? 1.0 : 0.0)
                    }
                    
                    
                    
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            showHelp = true
                        }, label: {
                            Image(systemName: "questionmark")
                                .accessibilityLabel("How To Play The Game")
                        })
                        .opacity((gameMode == .menu) ? 1 : 0)
                        .sheet(isPresented: $showHelp) {
                            NavigationStack {
                                VStack {
                                    Text("How to Play")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .fontDesign(.rounded)
                                    
                                    Divider()
                                    ScrollView {
                                        VStack {
                                            HStack {
                                                Text("🎲")
                                                Text("Each letter is picked at random from the English alphabet.")
                                                    .padding()
                                            }
                                            HStack {
                                                Text("🟣")
                                                Text("You are instructed to \"Tap the bubbles\" (cells) to form the letter for that round. The bubbles in the braille box start empty and will fill in when selected. ")
                                                    .padding()
                                            }
                                            HStack {
                                                Text("🎹")
                                                Text("If you select a bubble (cell) wrong, the game will notify you and you will try again until the letter is correctly created.")
                                                    .padding()
                                            }
                                            HStack {
                                                Text("✅")
                                                Text("When the letter is correctly created, you will receive a point, and a hear bell! Then you move on.")
                                                    .padding()
                                            }
                                            HStack {
                                                Text("🤔")
                                                Text("If you ever get stuck, you can always click the button at the bottom of the screen to see the alphabet in Braille.")
                                                    .padding()
                                            }
                                        }.frame(width: 350, alignment: .leading)
                                    }
                                    Divider()
                                    HStack {
                                        
                                        Text("Remember: This game is to teach the wonders of accessibility in our world. It's endless, so have fun learning!")
                                            .multilineTextAlignment(.center)
                                            .padding()
                                    }
                                    
                                }
                                .toolbar {
                                    ToolbarItem(placement: .navigation) {
                                        Button(action: {
                                            showHelp = false
                                        }, label: {
                                            Text("Done")
                                                .fontWeight(.bold)
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        
        }
        
 
}
