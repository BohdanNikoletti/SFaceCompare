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
                    waitUntil(timeout: 100) { done in
                        faceComparator.compareFaces(succes: { results in
                            expect(results).notTo(beEmpty())
                            done()
                        }, failure: { error in
                            fail(error.localizedDescription)
                            done()
                        })
                    }
                }
                it ("Same Nolan shots") {
                    let faceComparator = SFaceCompare.init(on: ImagesResources.christoferNolanFace,
                                                           and: ImagesResources.christoferNolanFace)
                    waitUntil(timeout: 100) { done in
                        faceComparator.compareFaces(succes: { results in
                            expect(results).notTo(beEmpty())
                            done()
                        }, failure: { error in
                            fail(error.localizedDescription)
                            done()
                        })
                    }
                }
            }
            context("Example with Michael Bay faces") {
                it ("Two different Bay shots") {
                    let faceComparator = SFaceCompare(on: ImagesResources.michaelBayFace,
                                                      and: ImagesResources.michaelBayFace2)
                    waitUntil(timeout: 100) { done in
                        faceComparator.compareFaces(succes: { results in
                            expect(results).notTo(beEmpty())
                            done()
                        }, failure: { error in
                            fail(error.localizedDescription)
                            done()
                        })
                    }
                }
                
                it ("Same Michael Bay shots") {
                    let faceComparator = SFaceCompare(on: ImagesResources.michaelBayFace,
                                                      and: ImagesResources.michaelBayFace)
                    waitUntil(timeout: 100) { done in
                        faceComparator.compareFaces(succes: { results in
                            expect(results).notTo(beEmpty())
                            done()
                        }, failure: { error in
                            fail(error.localizedDescription)
                            done()
                        })
                    }
                }
            }
        }
        describe("Faces on images are not the same") {
            context("Example with Christopher Nolan vs Michael Bay face") {
                it ("First data set") {
                    let faceComparator = SFaceCompare.init(on: ImagesResources.christoferNolanFace,
                                                           and: ImagesResources.michaelBayFace)
                    waitUntil(timeout: 100) { done in
                        faceComparator.compareFaces(succes: { results in
                            expect(results).to(beEmpty())
                            done()
                        }, failure: { error in
                            done()
                        })
                    }
                }
                it ("Second data set") {
                    let faceComparator = SFaceCompare.init(on: ImagesResources.christoferNolanFace2,
                                                           and: ImagesResources.michaelBayFace2)
                    waitUntil(timeout: 100) { done in
                        faceComparator.compareFaces(succes: { results in
                            expect(results).to(beEmpty())
                            done()
                        }, failure: { error in
                            done()
                        })
                    }
                }
            }
        }
    }
}
