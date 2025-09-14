import 'package:flutter/material.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:provider/provider.dart';

class Ikbtmbar extends StatefulWidget {
  List<BottomNavigationBarItem> items;
  int currentIndex;
  void Function(int) onTap;

  Ikbtmbar(
      {super.key,
        required this.items,
        required this.currentIndex,
        required this.onTap});


  @override
  State<Ikbtmbar> createState() => _IkbtmbarState();
}

class _IkbtmbarState extends State<Ikbtmbar> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
      height: 66,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
          itemCount: widget.items.length,
          // itemExtent: (MediaQuery.of(context).size.width-80)/4,
          // shrinkWrap: true,
          itemBuilder: (BuildContext ctx, int index) {
            return barItem(widget.items[index], index,ctx);
          },
        separatorBuilder: (BuildContext ctx, int index) {
          return SizedBox(width: (MediaQuery.of(context).size.width - 4*55 - 40)/3,);
        },
          ),
    );
  }

  Widget barItem(BottomNavigationBarItem item, int idx, BuildContext context) => GestureDetector(
        onTap: (){
          if(idx == 0){
            Provider.of<WorkController>(context, listen: false).onClickBtmIllkam();
          }
          widget.onTap(idx);
        },
        child: Stack(
          // alignment: Alignment.topRight,
          children: [
            Container(
              width: 55,
              height: 55,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: idx == widget.currentIndex ? Color(0xFF01A9DB) : Colors.transparent,
                shape: CircleBorder(
                  side: BorderSide(width:  1, color: idx == widget.currentIndex ? Color(0xFF01A9DB): Colors.transparent),
                ),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: item.icon,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    child: Text(
                      item.label ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: idx == widget.currentIndex ? Colors.white: Color(0xFFADADAD),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(idx == 2)
              Positioned(
                  top: 0,
                  right: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF01A9DB)
                    ),
                    child: Text(Provider.of<ChatsController>(context).unreadCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),

                    ),
                  )

              )


          ],
        ),


      );
}
