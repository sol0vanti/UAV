import UIKit

protocol MapScreenDelegate: AnyObject {
    func updateCollectionViewData()
    func didSelectAnnotation(title: String?)
}

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MapScreenDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    static var centerName: String?
    static var centerDetail: [[String: String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    func setUpVC(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func updateCollectionViewData() {
        collectionView.reloadData()
    }
    
    func didSelectAnnotation(title: String?) {
        print(title ?? showACError(text: "Unable to dequeue title while selecting annotation"))
        self.navigationItem.title = title
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let centerDetail = DetailViewController.centerDetail else {
            return 0
        }
        return centerDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailCollectionViewCell else {
            self.showACError(text: "Unable to dequeue a reusable cell")
            return UICollectionViewCell()
        }
        guard let item = DetailViewController.centerDetail?[indexPath.row] else {
            self.showACError(text: "unable to dequeue an item for cell")
            return UICollectionViewCell()
        }
        cell.titleLabel.text = item["title"]
        cell.detailLabel.text = item["detail"]
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 72)
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        pushVCTo(EventDetailViewController.self)
    }
}
