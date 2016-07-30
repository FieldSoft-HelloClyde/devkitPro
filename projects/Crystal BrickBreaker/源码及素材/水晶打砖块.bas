'��ˮ����ש�顷 ��һ��ƽ���� ���� (c) 2011

'��������: Windows7,BBIDE3.0��ǿ��,�ٷ�������
'���л���: PC-sim,�����߲�����BB2.0/2.1

'��л: ���ι����� ���� �ṩ�Ŀ������� , ������ �ṩ�ı���ͼƬ , �ڶ����ѵİ�����֧��

declare sub init()                  '��ʼ��
declare sub main()                  '������
declare sub newgame()               '��������Ϸ
declare sub reshow()                '������ʾש��
declare function canclick(cx,cy)    '�ж�cx,cy��ש���Ƿ���Ե��   ����ֵ ���Ե��=1 �����Ե��=0
declare sub explode(cx,cy)          '����cx,cy��ש��ĵ��
declare sub addqueue(cx,cy)         '��cx,cy��ש��������
declare sub falldown()              '�������
declare sub judgewin()              '�ж��Ƿ�Ӯ
declare sub dealbomb(cx,cy)         '������cx,cy��ʹ�õ�ը��
declare sub wait(ms)                '�ȴ�ms����
declare sub judgenoway()            '�ж��Ƿ���·����
declare sub savehero()              '����Ӣ�۰�
declare sub loadhero()              '��ȡӢ�۰�
declare sub combine()               '�����Զ��ϲ�
declare sub help()                  '��������
declare sub shownum(pg,num,cx,cy,sign)
						'��pgҳ����cx,xy����ʾnum   signΪ���ſ���
declare function addscore(bricks)   '�ӷ��㷨 bricksΪ�����ש����   ����ֵ ���ӵķ���

const appname="ˮ����ש��"          '������
const authorname="��һ��ƽ����"     '������
const version="ver 3.0"             '����汾��
const date="2011-10-1"              '����޸�����
const bricknum=7                    'ש���������
const bricksize=24                  'ש��߳�(����)
const xmax=10                       '����ש����
const ymax=10                       '����ש����
const allmax=100                    '��ש����
const savfile="ˮ����ש��Ӣ�۰�.dat"'Ӣ�۰��ļ���

dim ext$,resfile$                   '��Դ�ļ���׺,��Դ�ļ���
dim page                            '��̨ҳ��
dim mainpic,backpic,newrecordpic,newgamepic,winpic,explodingpic,nowaypic,gamemenupic,herolistpic,helppic,numpic,brickpic(bricknum)
                                    '����ͼƬ
dim x,y,i,j,k,n,temp,x$,p,xx        '��ʱ����
dim map(xmax,ymax)                  '��ͼ
dim queue(allmax,2),qmax,qpointer   '����,���н�β,����ָ��
dim currentcolor,bombnum,win,speed,fallingcount,noway
                                    '��ǰ��ɫ,ը������,�Ƿ�Ӯ,��ǰ�����ٶ�,�������,�Ƿ���·����
dim space(xmax),emptyline,lastbrickline
                                    'ÿ��������Ŀ�ש��λ��,������Ŀ���,������ķǿ���
dim animationon,combineon,difficulty'��������,�Զ�����ϲ�����,�Ѷ�
dim initspeed,addspeed              '���ٶ�,���ٶ�
dim loop                            'ѭ������
dim starttick                       '��ʼʱ��
dim score,heroscore,addr            '����,Ӣ�۰����,�ļ�ƫ��

sub init()
	setlcd(240,320)
	color(&hffff,0,&hffff)
	font(font_16song)
	page=createpage()
	if getenv!()=0.0 then
		ext$=".rlb"
		initspeed=1
		addspeed=1
	else
		ext$=".lib"
		initspeed=5
		addspeed=5
	end if
	resfile$=appname+ext$
	mainpic=loadres(resfile$,1+bricknum)
	backpic=loadres(resfile$,2+bricknum)
	newrecordpic=loadres(resfile$,3+bricknum)
	newgamepic=loadres(resfile$,4+bricknum)
	winpic=loadres(resfile$,5+bricknum)
	explodingpic=loadres(resfile$,6+bricknum)
	nowaypic=loadres(resfile$,7+bricknum)
	gamemenupic=loadres(resfile$,8+bricknum)
	herolistpic=loadres(resfile$,9+bricknum)
	helppic=loadres(resfile$,10+bricknum)
	numpic=loadres(resfile$,11+bricknum)
	n=1
	while n<=bricknum
		brickpic(n-1)=loadres(resfile$,n)
		n=n+1
	wend
	showpic(-1,mainpic,0,0,240,320,0,0,1)
	waitkey()
	difficulty=4
	animationon=1
	combineon=1
	randomize(gettick())
	open savfile for binary as #1
	if lof(1)<20 then
		n=0
		temp=0
		while n<5
			put #1,temp
			n=n+1
		wend
	end if
	close #1
end sub

sub main()
	newgame()
	while 1
		k=waitkey()
		if k=27 then
			end
		else if k<0 then
			x=getpenposx(k)
			y=getpenposy(k)
			if y<bricksize*ymax then
				x=x/bricksize
				y=y/bricksize
				if map(x,y)=bricknum then
					dealbomb(x,y)
				else if canclick(x,y) then
					explode(x,y)
				end if
			else if x<160 then
				if y<280 and x<80 then
					showpic(-1,newgamepic,0,240,240,80,0,0,1)
					k=waitkey()
					if k<0 then
						x=getpenposx(k)
						y=getpenposy(k)
						if y>272 then
							difficulty=x/48+2
							newgame()
						end if
					end if
					reshow()
				else if y>=280 and x<80 then
					help()
				else if y<280 and x>=80 then
					loadhero()
				else if y>=280 and x>=80 then
					end
				end if
			end if
		end if
		judgewin()
		judgenoway()
	wend
end sub

sub newgame()
	i=0
	while i<xmax
		j=0
		while j<ymax
			map(i,j)=rnd(difficulty)+1
			j=j+1
		wend
		i=i+1
	wend
	bombnum=difficulty*2-4
	i=0
	while i<bombnum
		x=rnd(xmax)
		y=rnd(xmax)
		while map(x,y)=bricknum
			x=rnd(xmax)
			y=rnd(xmax)
		wend
		map(x,y)=bricknum
		i=i+1
	wend
	score=0
	reshow()
end sub

sub reshow()
	showpic(page,backpic,0,0,240,320,0,0,1)
	showpic(page,gamemenupic,0,240,240,80,0,0,1)
	i=0
	while i<xmax
		j=0
		while j<ymax
			if map(i,j) then
				showpic(page,brickpic(map(i,j)-1),i*bricksize,j*bricksize,bricksize,bricksize,0,0,1)
			end if
			j=j+1
		wend
		i=i+1
	wend
	shownum(page,score,160,275,0)
	flippage(page)
end sub

function canclick(cx,cy)
	temp=0
	currentcolor=map(cx,cy)
	if currentcolor > 0 then
		if cx>0 then temp=temp+(map(cx-1,cy)=currentcolor)
		if cy>0 then temp=temp+(map(cx,cy-1)=currentcolor)
		if cx<xmax-1 then temp=temp+(map(cx+1,cy)=currentcolor)
		if cy<ymax-1 then temp=temp+(map(cx,cy+1)=currentcolor)
		canclick=temp
	else
		canclick = 0
	end if
end function

sub explode(cx,cy)
	qmax=0
	qpointer=0
	currentcolor=map(cx,cy)
	addqueue(cx,cy)
	map(cx,cy)=0
	while qpointer<qmax
		i=queue(qpointer,0)
		j=queue(qpointer,1)
		if i<xmax-1 then
			if currentcolor=map(i+1,j) then
				addqueue(i+1,j)
				map(i+1,j)=0
			end if
		end if
		if i>0 then
			if currentcolor=map(i-1,j) then
				addqueue(i-1,j)
				map(i-1,j)=0
			end if
		end if
		if j<ymax-1 then
			if currentcolor=map(i,j+1) then
				addqueue(i,j+1)
				map(i,j+1)=0
			end if
		end if
		if j>0 then
			if currentcolor=map(i,j-1) then
				addqueue(i,j-1)
				map(i,j-1)=0
			end if
		end if
		qpointer=qpointer+1
	wend
	score=score+addscore(qmax)
	falldown()
	combine()
	reshow()
end sub

sub addqueue(cx,cy)
	queue(qmax,0)=cx
	queue(qmax,1)=cy
	qmax=qmax+1
end sub

sub falldown()
	speed=initspeed
	loop=1
	while loop
		i=0
		while i<xmax
			j=0
			space(i)=-1
			while j<ymax
				if map(i,j)=0 then space(i)=j
				j=j+1
			wend
			i=i+1
		wend
		i=0
		loop=0
		while i<xmax and not loop
			j=0
			while j<space(i) and not loop
				if map(i,j) then
					loop=1
				end if
				j=j+1
			wend
			i=i+1
		wend
		if loop=1 then
			if animationon then
				fallingcount=0
				while fallingcount<bricksize
					showpic(page,backpic,0,0,240,320,0,0,1)
					showpic(page,gamemenupic,0,240,240,80,0,0,1)
					i=0
					while i<xmax
						j=0
						while j<ymax
							if j<space(i) then
								if map(i,j) then showpic(page,brickpic(map(i,j)-1),i*bricksize,j*bricksize+fallingcount,bricksize,bricksize,0,0,1)
							else
								if map(i,j) then showpic(page,brickpic(map(i,j)-1),i*bricksize,j*bricksize,bricksize,bricksize,0,0,1)
							end if
							j=j+1
						wend
						i=i+1
					wend
					if qmax then shownum(page,addscore(qmax),80,100,1)
					flippage(page)
					fallingcount=fallingcount+speed
				wend
			end if
			i=0
			while i<xmax
				j=space(i)
				while j>0
					map(i,j)=map(i,j-1)
					j=j-1
				wend
				if space(i)>=0 then map(i,0)=0
				i=i+1
			wend
			speed=speed+addspeed
		end if
	wend
end sub

sub judgewin()
	win=1
	i=0
	while i<xmax and win
		j=ymax-1
		while j>=0 and win
			if map(i,j) then win=0
			j=j-1
		wend
		i=i+1
	wend
	if win then
		wait(200)
		showpic(-1,winpic,0,0,240,320,0,0,1)
		shownum(-1,score,80,160,0)
		savehero()
		waitkey()
		newgame()
	end if
end sub

sub dealbomb(cx,cy)
	qmax=0
	qpointer=0
	addqueue(cx,cy)
	while qpointer<qmax
		i=queue(qpointer,0)
		j=queue(qpointer,1)
		if i>=0 and j>=0 and i<xmax and j<ymax then
			if map(i,j)=bricknum then
				addqueue(i+1,j)
				addqueue(i+1,j+1)
				addqueue(i+1,j-1)
				addqueue(i,j+1)
				addqueue(i,j-1)
				addqueue(i-1,j)
				addqueue(i-1,j+1)
				addqueue(i-1,j-1)
				addqueue(i+2,j)
				addqueue(i-2,j)
				addqueue(i,j+2)
				addqueue(i,j-2)
			end if
			map(i,j)=0
			showpic(-1,explodingpic,i*bricksize,j*bricksize,bricksize,bricksize,0,0,1)
		end if
		qpointer=qpointer+1
	wend
	qmax=0
	wait(100)
	falldown()
	combine()
	reshow()
end sub

sub wait(ms)
	starttick=gettick()
	while gettick()<starttick+ms
	wend
end sub

sub judgenoway()
	noway=1
	i=0
	while i<xmax and noway
		j=ymax-1
		while j>=0 and noway
			if canclick(i,j) or map(i,j)=bricknum then noway=0
			j=j-1
		wend
		i=i+1
	wend
	if noway then
		wait(200)
		showpic(-1,nowaypic,0,0,240,320,0,0,1)
		waitkey()
		newgame()
	end if
end sub

sub savehero()
	open savfile for binary as #1
	addr=(difficulty-2)*4
	seek #1,addr
	get #1,heroscore
	if heroscore<score then
		showpic(-1,newrecordpic,0,200,240,40,0,0,1)
		seek #1,addr
		put #1,score
	end if
	close #1
end sub

sub loadhero()
	showpic(-1,herolistpic,0,0,240,320,0,0,1)
	open savfile for binary as #1
	n=2
	while n<=6
		get #1,heroscore
		shownum(-1,n,10,40+n*36,0)
		shownum(-1,heroscore,130,40+n*36,0)
		n=n+1
	wend
	close #1
	waitkey()
	reshow()
end sub

sub combine()
	if combineon then
		loop=1
		speed=initspeed
		while loop
			emptyline=xmax
			lastbrickline=-1
			i=0
			while i<xmax
				if map(i,ymax-1)=0 then
					if loop then
						emptyline=i
						loop=0
					end if
				else
					lastbrickline=i
				end if
				i=i+1
			wend
			loop=1
			if emptyline<lastbrickline then
				if animationon then
					fallingcount=0
					while fallingcount<bricksize
						showpic(page,backpic,0,0,240,320,0,0,1)
						showpic(page,gamemenupic,0,240,240,80,0,0,1)
						i=0
						while i<xmax
							j=0
							while j<ymax
								if i>emptyline then
									if map(i,j) then showpic(page,brickpic(map(i,j)-1),i*bricksize-fallingcount,j*bricksize,bricksize,bricksize,0,0,1)
								else
									if map(i,j) then showpic(page,brickpic(map(i,j)-1),i*bricksize,j*bricksize,bricksize,bricksize,0,0,1)
								end if
								j=j+1
							wend
							i=i+1
						wend
						if qmax then shownum(page,addscore(qmax),80,100,1)
						flippage(page)
						fallingcount=fallingcount+speed
					wend
				end if
				i=emptyline+1
				while i<xmax
					j=0
					while j<ymax
						map(i-1,j)=map(i,j)
						j=j+1
					wend
					i=i+1
				wend
				j=0
				while j<ymax
					map(xmax-1,j)=0
					j=j+1
				wend
			else
				loop=0
			end if
			speed=speed+addspeed
		wend
	end if
end sub

sub help()
	showpic(-1,helppic,0,0,240,320,0,0,1)
	waitkey()
	reshow
end sub

sub shownum(pg,num,cx,cy,sign)
	x$=str$(num)
	xx=cx+40-len(x$)*10
	p=0
	if sign then
		showpic(pg,numpic,xx-20,cy,20,40,200,0,1)
	end if
	while p<len(x$)
		temp=val(mid$(x$,p,1))
		showpic(pg,numpic,xx,cy,20,40,temp*20,0,1)
		p=p+1
		xx=xx+20
	wend
end sub

function addscore(bricks)
	addscore=bricks*(bricks-1)
end function

init()
main()