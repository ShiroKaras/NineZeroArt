//
//  SKUserAgreementViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/5/23.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKUserAgreementViewController.h"
#import "HTUIHeader.h"
@interface SKUserAgreementViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SKUserAgreementViewController {
	float lastOffsetY;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)createUI {
	self.view.backgroundColor = [UIColor blackColor];

	_textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_HEIGHT - 20)];
	[self.view addSubview:_textView];
	_textView.delegate = self;
	_textView.backgroundColor = [UIColor clearColor];
	_textView.editable = NO;
	_textView.textColor = [UIColor colorWithHex:0xCBCBCB];
	_textView.contentOffset = CGPointMake(0, 0);
	_textView.text = @"\n\n\n\n重要须知：\n\n    深圳九零九五网络科技有限公司在此特别提醒用户认真阅读、充分理解本《服务协议》（下称《协议》）用户应认真阅读、充分理解本《协议》中各条款，包括免除或者限制深圳九零九五网络科技有限公司责任的免责条款及对用户的权利限制条款。请您审慎阅读并选择接受或不接受本《协议》（未成年人应在法定监护人陪同下阅读）。除非您接受本《协议》所有条款，否则您无权注册、登录或使用本协议所涉相关服务。您的注册、登录、使用等行为将视为对本《协议》的接受，并同意接受本《协议》各项条款的约束。\n\n    一、使用规则\n\n    1、用户充分了解并同意，深圳九零九五网络科技有限公司的手机应用产品九零APP，仅为用户提供本公司原创动漫，原创文章以及活动策划。用户必须为自己注册账号下的一切行为负责。用户应对深圳九零九五网络科技有限公司的手机应用产品九零APP中的内容自行加以判断，并承担因使用内容而引起的所有风险，包括因对内容的正确性、完整性或实用性的依赖而产生的风险。深圳九零九五网络科技有限公司无法且不会对因用户行为而导致的任何损失或损害承担责任。\n    2、用户在深圳九零九五网络科技有限公司的手机应用产品九零App或通过深圳九零九五网络科技有限公司旗下的任意一产品、平台转出的任何内容并不反映深圳九零九五网络科技有限公司的观点或政策，深圳九零九五网络科技有限公司对此不承担任何责任。\n    3、用户充分了解并同意，深圳九零九五网络科技有限公司的手机应用产品－九零APP是一款基于原创动画人物零仔以视频、文章、侦探解谜以及活动为主体的内容平台产品，用户须对在九零APP上注册信息的真实性、合法性、有效性承担全部责任。用户不得冒充他人，不得利用他人的名义传播任何信息，不得恶意使用注册账号导致其他用户误认。否则深圳九零九五网络科技有限公司有权立即停止提供服务，收回用户九零APP的账号并由用户独自承担由此而产生的一切法律责任。\n    4、用户须对九零APP上所传播信息的真实性、合法性、无害性、有效性等全权负责，与用户所传播的信息相关的任何法律责任由用户自行承担，与九零APP以及深圳九零九五网络科技有限公司无关。\n    5、深圳九零九五网络科技有限公司保留因业务发展需要，单方面对本服务的全部或部分服务内容在任何时候不经任何通知的情况下变更、暂停、限制、终止或撤销深圳九零九五网络科技有限公司九零APP服务的权利，用户需承担此风险。\n    6、九零APP提供的服务中可能包括广告，用户同意在使用过程中显示九零APP和第三方供应商、合作伙伴提供的广告。\n    7、用户不得抄袭或利用九零APP制作、上载、复制、发送如下内容：\n\n    (1) 反对宪法所确定的基本原则的；\n    (2) 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n    (3) 损害国家荣誉和利益的；\n    (4) 煽动民族仇恨、民族歧视，破坏民族团结的；\n    (5) 破坏国家宗教政策，宣扬邪教和封建迷信的；\n    (6) 散布谣言，扰乱社会秩序，破坏社会稳定的；\n    (7) 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n    (8) 侮辱或者诽谤他人，侵害他人合法权益的；\n    (9) 含有法律、行政法规禁止的其他内容的信息。\n    8、深圳九零九五网络科技有限公司可依其合理判断，对违反有关法律法规或本协议约定；侵犯、妨害、威胁任何人权利或安全的内容；假冒他人的行为。深圳九零九五网络科技有限公司有权依法停止传输任何前述内容，并有权依其自行判断对违反本条款的任何人士采取适当的法律行动，包括但不限于从九零APP中删除具有违法性、侵权性、不当性等内容，终止违反者的成员资格，阻止其使用九零APP全部或部分服务，并且依据法律法规保存有关信息并向有关部门报告等。\n    9、用户权利及义务：\n    (1) 九零APP账号的所有权归深圳九零九五网络科技有限公司所有，用户完成申请注册手续后，获得九零APP账号的使用权，该使用权仅属于初始申请注册人，禁止赠与、借用、租用、转让或售卖。深圳九零九五网络科技有限公司因经营需要，有权回收用户的九零APP账号。\n    (2) 用户有权更改、删除在九零APP上的个人资料、注册信息及传送内容等，但需注意，删除有关信息的同时也会删除任何用户储存在系统中的文字和图片。用户需承担该风险。\n    (3) 用户有责任妥善保管注册账号信息及账号密码的安全，用户需要对注册账号以及密码下的行为承担法律责任。用户同意在任何情况下不使用其他成员的账号或密码。在您怀疑他人在使用您的账号或密码时，您同意立即通知九零APP。\n    (4) 用户应遵守本协议的各项条款，正确、适当地使用本服务，如因用户违反本协议中的任何条款，深圳九零九五网络科技有限公司有权依据协议终止对违约用户九零APP账号提供服务。同时，深圳九零九五网络科技有限公司保留在任何时候收回九零APP账号、用户名的权利。\n    (5) 用户注册九零APP账号后如果长期不登录该账号，深圳九零九五网络科技有限公司有权回收该账号，以免造成资源浪费，由此带来问题均由用户自行承担。\n    10，用户不得利用九零APP产品内的原创动漫形象，原创动漫视频，以及与零仔相关的一切内容从事任何盈利和宣传行为。\n    11，应用内线下活动，深圳九零九五网络科技公司用户最终解释权。用户须遵守活动规则。\n\n    二、隐私保护\n\n    用户同意个人隐私信息是指那些能够对用户进行个人辨识或涉及个人通信的信息，包括下列信息：用户真实姓名，身份证号，手机号码，IP地址等。非个人隐私信息是指用户对本服务的操作状态以及使用习惯等一些明确且客观反映在九零APP服务器端的基本记录信息和其他一切个人隐私信息范围外的普通信息以及用户同意公开的上述隐私信息。\n    尊重用户个人隐私信息的私有性是九零APP的一贯制度，九零APP将会采取合理的措施保护用户的个人隐私信息，除法律或有法律赋予权限的政府部门要求或用户同意等原因外，深圳九零九五网络科技有限公司未经用户同意不向除合作单位以外的第三方公开、 透露用户个人隐私信息。 但是，用户在注册时选择同意，或用户与深圳九零九五网络科技有限公司及合作单位之间就用户个人隐私信息公开或使用另有约定的除外，同时用户应自行承担因此可能产生的任何风险，深圳九零九五网络科技有限公司对此不予负责。同时，为了运营和改善深圳九零九五网络科技有限公司的技术和服务，深圳九零九五网络科技有限公司将可能会自行收集使用或向第三方提供用户的非个人隐私信息，这将有助于九零APP向用户提供更好的用户体验和提高九零APP的服务质量。\n    用户同意，在使用九零APP的服务时也同样受深圳九零九五网络科技有限公司隐私政策的约束。当您接受本协议条款时，您同样认可并接受深圳九零九五网络科技有限公司隐私政策的条款。\n\n    三、九零APP商标信息\n\n    九零APP服务中所涉及的图形、文字或其组成，以及其他深圳九零九五网络科技有限公司标志及产品、服务名称，均为深圳九零九五网络科技有限公司之商标（以下简称“九零标识”）。未经深圳九零九五网络科技有限公司事先书面同意，用户不得将九零标识以任何方式展示、使用或做其他处理，也不得向他人表明您有权展示、使用、或其他有权处理九零标识的行为。\n\n    四、法律责任及免责\n    \n    1、用户违反本《协议》或相关的服务条款的规定，导致或产生的任何第三方主张的任何索赔、要求或损失，包括合理的律师费，用户同意赔偿深圳九零九五网络科技有限公司、合作公司以及关联公司，并使之免受损害。\n    2、用户因第三方如电信部门的通讯线路故障、技术问题、网络、电脑故障、系统不稳定性及其他各种不可抗力原因而遭受的一切损失，深圳九零九五网络科技有限公司及合作单位不承担责任。\n    3、因技术故障等不可抗事件影响到服务的正常运行的，深圳九零九五网络科技有限公司及合作单位承诺在第一时间内与相关单位配合，及时处理进行修复，但用户因此而遭受的一切损失，深圳九零九五网络科技有限公司及合作单位不承担责任。\n    4、本服务同大多数互联网服务一样，受包括但不限于用户原因、网络服务质量、社会环境等因素的差异影响，可能受到各种安全问题的侵扰，如他人利用用户的资料，造成现实生活中的骚扰；用户下载安装的其它软件或访问的其他网站中含有“特洛伊木马”等病毒，威胁到用户的计算机信息和数据的安全，继而影响本服务的正常使用等等。用户应加强信息安全及使用者资料的保护意识，要注意加强密码保护，以免遭致损失和骚扰。\n    5、用户须明白，使用本服务因涉及Internet服务，可能会受到各个环节不稳定因素的影响。因此，本服务存在因不可抗力、计算机病毒、黑客攻击、系统不稳定、用户所在位置、用户关机以及其他任何技术、互联网络、通信线路原因等造成的服务中断或不能满足用户要求的风险。用户须承担以上风险，深圳九零九五网络科技有限公司不作担保。对因此导致用户不能发送和接受阅读信息或接发错信息，深圳九零九五网络科技有限公司不承担任何责任。\n    6、用户须明白，在使用九零APP服务过程中存在来自任何他人的包括威胁性的、诽谤性的、令人反感的或非法的内容或行为或对他人权利的侵犯（包括知识产权）的匿名或冒名的信息的风险，用户须承担以上风险，深圳九零九五网络科技有限公司和合作公司对本服务不作任何类型的担保，不论是明确的或隐含的，包括所有有关信息真实性、适商性、适于某一特定用途、所有权和非侵权性的默示担保和条件，对因此导致任何因用户不正当或非法使用服务产生的直接、间接、偶然、特殊及后续的损害，不承担任何责任。\n    7、深圳九零九五网络科技有限公司定义的信息内容包括且不仅限于：文字、软件、声音、相片、录像、图表、视频、谜题、动画；广告中的全部内容；深圳九零九五网络科技有限公司为用户提供的商业信息。所有这些内容受版权、商标权、其它知识产权以及所有权法律的保护。所以，用户只能在深圳九零九五网络科技有限公司和广告商授权下才能使用这些内容，不能擅自复制、修改、编纂这些内容，不能创造与内容有关的衍生产品。\n    8、在任何情况下，深圳九零九五网络科技有限公司均不对任何间接性、后果性、惩罚性、偶然性、特殊性、刑罚性的，包括因用户使用九零APP的服务而遭受的利润损失，承担责任（即使深圳九零九五网络科技有限公司已被告知该等损失的可能性亦然）。尽管本协议中可能含有相悖的规定，深圳九零九五网络科技有限公司对您承担的全部责任，无论因何种原因或何种行为方式，始终不超过您在成员期内因使用九零APP服务而支付给深圳九零九五网络科技有限公司的费用(如有) 。\n    9、APP内奖品发放及后续服务由九零APP及合作商提供，与苹果公司及iOS AppStore无关。\n    10、我们鼓励父母或监护人指导未满十八岁的未成年人使用我们的服务。我们建议未成年人鼓励他们的父母或监护人阅读本《协议》，并建议未成年人在提交的个人信息之前寻求父母或监护人的同意和指导。\n\n    五、九零APP管理规则\n\n    九零APP是和现实相关的社交产品，希望用户相互尊重，遵循和现实社会一样的社交礼仪。为避免遭到用户举报而被封禁设备，请您遵守以下原则：\n    1、请勿发送涉嫌性骚扰的文字、图片及语音信息；\n    2、请勿使用含色情、淫秽意味或其他令人不适的头像或资料；\n    3、请勿在交谈中使用辱骂、恐吓、威胁等言论；\n    4、请勿发布各类垃圾广告、恶意信息、诱骗信息；\n    5、请勿盗用他人头像或资料，请勿伪装他人身份；\n    6、请勿发布不当政治言论或者任何违反国家法规政策的言论。\n    如用户违反社区管理规则，深圳九零九五网络科技有限公司公司有权依据协议终止对违约用户九零APP账号提供服务。同时，深圳九零九五网络科技有限公司保留在任何时候收回九零APP账号的权力。\n\n    六、其他条款\n\n    1、深圳九零九五网络科技有限公司郑重提醒用户注意本《协议》中免除深圳九零九五网络科技有限公司责任和加重用户义务的条款，请用户仔细阅读，自主考虑风险。未成年人应在法定监护人的陪同下阅读本《协议》。以上各项条款内容的最终解释权及修改权归深圳九零九五网络科技有限公司所有。\n    2、本《协议》所定的任何条款的部分或全部无效者，不影响其它条款的效力。\n    3、本《协议》的版权由深圳九零九五网络科技有限公司所有，深圳九零九五网络科技有限公司保留一切解释和修改权利。\n\n";

	CGRect textFrame = [[self.textView layoutManager] usedRectForTextContainer:[self.textView textContainer]];
	_textView.contentSize = textFrame.size;

	UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rank_shading"]];
	backImageView.tag = 202;
	backImageView.alpha = 0;
	backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
	backImageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:backImageView];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
	headerView.tag = 200;
	headerView.backgroundColor = [UIColor clearColor];
	UILabel *titleLabel = [UILabel new];
	titleLabel.text = @"用户协议";
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = PINGFANG_FONT_OF_SIZE(17);
	[titleLabel sizeToFit];
	titleLabel.center = headerView.center;
	[headerView addSubview:titleLabel];
	[self.view addSubview:headerView];

//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.tag = 9001;
//	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//	[backButton setImage:[UIImage imageNamed:@"btn_logins_back"] forState:UIControlStateNormal];
//	[backButton setImage:[UIImage imageNamed:@"btn_logins_back_highlight"] forState:UIControlStateHighlighted];
//	[backButton sizeToFit];
//	[self.view addSubview:backButton];
//	backButton.top += 12;
//	backButton.left += 4;
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y <= 64) {
		[UIView animateWithDuration:0.3
				 animations:^{
				     [self.view viewWithTag:9001].alpha = 1;
				     [self.view viewWithTag:200].alpha = 1;
				     [self.view viewWithTag:202].alpha = 0;
				     [self.view viewWithTag:9001].bottom = [self.view viewWithTag:9001].height + 12;
				     [self.view viewWithTag:200].bottom = [self.view viewWithTag:200].height;
				     [self.view viewWithTag:202].bottom = [self.view viewWithTag:202].height;
				 }
				 completion:^(BOOL finished){

				 }];
	} else {
		if (lastOffsetY >= scrollView.contentOffset.y) {
			[UIView animateWithDuration:0.3
					 animations:^{
					     //显示
					     [self.view viewWithTag:9001].alpha = 1;
					     [self.view viewWithTag:200].alpha = 1;
					     [self.view viewWithTag:202].alpha = 1;
					     [self.view viewWithTag:9001].bottom = [self.view viewWithTag:9001].height + 12;
					     [self.view viewWithTag:200].bottom = [self.view viewWithTag:200].height;
					     [self.view viewWithTag:202].bottom = [self.view viewWithTag:202].height;
					 }
					 completion:^(BOOL finished){

					 }];
		} else {
			[UIView animateWithDuration:0.3
					 animations:^{
					     //隐藏
					     [self.view viewWithTag:9001].alpha = 0;
					     [self.view viewWithTag:200].alpha = 0;
					     [self.view viewWithTag:202].alpha = 0;
					     [self.view viewWithTag:9001].bottom = 0;
					     [self.view viewWithTag:200].bottom = 0;
					     [self.view viewWithTag:202].bottom = 0;
					 }
					 completion:^(BOOL finished){

					 }];
		}
	}
	lastOffsetY = scrollView.contentOffset.y;
}

@end
