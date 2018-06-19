// https://github.com/Quick/Quick

import Quick
import Nimble
import SFaceCompare

struct ImagesResources {
    private static let bundle = Bundle(for: FaceCompareSpec.self)
    private init() { }
    static let normalFemaleFace: UIImage! = UIImage(named: "NormalFemaleFace", in: bundle, compatibleWith: nil)
    static let normalMaleFace: UIImage! = UIImage(named: "NormalMaleFace", in: bundle, compatibleWith: nil)
    static let christoferNolanFace: UIImage! = UIImage(named: "ChristopherNolan", in: bundle, compatibleWith: nil)
    static let christoferNolanFace2: UIImage! = UIImage(named: "ChristopherNolan2", in: bundle, compatibleWith: nil)
    static let michaelBayFace: UIImage! = UIImage(named: "MichaelBay", in: bundle, compatibleWith: nil)
    static let michaelBayFace2: UIImage! = UIImage(named: "MichaelBay2", in: bundle, compatibleWith: nil)
    
}

final class FaceCompareSpec: QuickSpec {
    override func spec() {
        describe("Faces on images are the same") {
            context("Example with Christopher Nolan faces") {
                it ("Two different Nolan shots") {
                    let faceComparator = SFaceCompare.init(on: ImagesResources.christoferNolanFace,
                                                           and: ImagesResources.christoferNolanFace2)
                    faceComparator.compareFaces(succes: { [weak self] results in
                        
                        }, failure: { [weak self] error in
                            fail(error.localizedDescription)
                    })
                }
                
                
                it("will eventually pass") {
                    var time = "passing"
                    
                    DispatchQueue.main.async {
                        time = "done"
                    }
                    
                    waitUntil { done in
                        Thread.sleep(forTimeInterval: 0.5)
                        expect(time) == "done"
                        
                        done()
                    }
                }
            }
        }
    }
}
