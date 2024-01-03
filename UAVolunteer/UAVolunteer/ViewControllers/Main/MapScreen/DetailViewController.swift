import UIKit

protocol MapScreenDelegate: AnyObject {
    func updateCollectionViewData()
    func didSelectAnnotation(title: String?)
}

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MapScreenDelegate {
    func didSelectAnnotation(title: String?) {
        print("===============================")
        print(title ?? fatalError("unable to dequeue title while selecting annotation"))
        self.navigationItem.title = title
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    static var centerName: String?
    static var centerDetail: [[String: String]]?
    
    func updateCollectionViewData() {
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    func setUpVC(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let centerDetail = DetailViewController.centerDetail else {
            return 0
        }
        return centerDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailCollectionViewCell else {
            fatalError("unable to dequeue a reusable cell")
        }
        guard let item = DetailViewController.centerDetail?[indexPath.row] else {
            fatalError("unable to dequeue an item for cell")
        }
        cell.titleLabel.text = item["title"]
        cell.detailLabel.text = item["detail"]
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 72)
    }
}
