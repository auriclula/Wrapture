FasdUAS 1.101.10   ��   ��    k             l     ����  r       	  I     �� 
���� 0 
fileexists 
FileExists 
  ��  m       �   , / u s r / l o c a l / b i n / f f p r o b e��  ��   	 o      ���� 0 foundffprobe foundFFprobe��  ��        l  	  ����  r   	     I   	 �� ���� 0 
fileexists 
FileExists   ��  m   
    �   * / u s r / l o c a l / b i n / f f p l a y��  ��    o      ���� 0 foundffplay foundFFplay��  ��        l    ����  r        m       �  * h t t p s : / / m e d i a s t r e a m . i t s . t x s t a t e . e d u / s t r e a m i n g / _ d e f i n s t _ / m p 4 : T e x a s S t a t e U n i v e r s i t y / S R S / M a r k E r i c k s o n - m e 0 2 / T L - c - a m 7 Y K 5 X U W B t b e x f m V m b A - T L . m p 4 / p l a y l i s t . m 3 u 8  o      ����  0 actuallinktest actualLinkTest��  ��        l     ����   r     ! " ! m     # # � $ $0 u n t i t l e d : / / m e d i a s t r e a m . i t s . t x s t a t e . e d u / s t r e a m i n g / _ d e f i n s t _ / m p 4 : T e x a s S t a t e U n i v e r s i t y / S R S / M a r k E r i c k s o n - m e 0 2 / T L - c - a m 7 Y K 5 X U W B t b e x f m V m b A - T L . m p 4 / p l a y l i s t . m 3 u 8 " o      ����  0 safarilinktest safariLinkTest��  ��     % & % l     �� ' (��   ' � �https://mediastream.its.txstate.edu:443/streaming/_definst_/mp4:TexasStateUniversity/SRS/MarkErickson-me02/TL-DNSGEzJlQ0aun3RQ8TWEMA-TL.mp4/playlist.m3u8    ( � ) )2 h t t p s : / / m e d i a s t r e a m . i t s . t x s t a t e . e d u : 4 4 3 / s t r e a m i n g / _ d e f i n s t _ / m p 4 : T e x a s S t a t e U n i v e r s i t y / S R S / M a r k E r i c k s o n - m e 0 2 / T L - D N S G E z J l Q 0 a u n 3 R Q 8 T W E M A - T L . m p 4 / p l a y l i s t . m 3 u 8 &  * + * l     �� , -��   , � � /usr/local/bin/ffplay -autoexit -f  lavfi 'amovie=https://mediastream.its.txstate.edu:443/streaming/_definst_/mp4:TexasStateUniversity/SRS/MarkErickson-me02/TL-DNSGEzJlQ0aun3RQ8TWEMA-TL.mp4/playlist.m3u8,channelmap=0|1|2|3|6|7|4|5:7.1' &    - � . .�   / u s r / l o c a l / b i n / f f p l a y   - a u t o e x i t   - f     l a v f i   ' a m o v i e = h t t p s : / / m e d i a s t r e a m . i t s . t x s t a t e . e d u : 4 4 3 / s t r e a m i n g / _ d e f i n s t _ / m p 4 : T e x a s S t a t e U n i v e r s i t y / S R S / M a r k E r i c k s o n - m e 0 2 / T L - D N S G E z J l Q 0 a u n 3 R Q 8 T W E M A - T L . m p 4 / p l a y l i s t . m 3 u 8 , c h a n n e l m a p = 0 | 1 | 2 | 3 | 6 | 7 | 4 | 5 : 7 . 1 '   & +  / 0 / l     ��������  ��  ��   0  1 2 1 l     �� 3 4��   3   check for ffmpeg    4 � 5 5 "   c h e c k   f o r   f f m p e g 2  6 7 6 l    8���� 8 r     9 : 9 m    ��
�� boovtrue : o      ���� 0 	showerror 	showError��  ��   7  ; < ; l   5 =���� = Z    5 > ?���� > =   ! @ A @ o    ���� 0 foundffplay foundFFplay A m     ��
�� boovtrue ? Z   $ 1 B C���� B =  $ ' D E D o   $ %���� 0 foundffprobe foundFFprobe E m   % &��
�� boovtrue C r   * - F G F m   * +��
�� boovfals G o      ���� 0 	showerror 	showError��  ��  ��  ��  ��  ��   <  H I H l     ��������  ��  ��   I  J K J l     �� L M��   L   no ffmpeg found    M � N N     n o   f f m p e g   f o u n d K  O P O l     �� Q R��   Q   exit gracefully...    R � S S &   e x i t   g r a c e f u l l y . . . P  T U T l  6 T V���� V Z   6 T W X���� W =  6 9 Y Z Y o   6 7���� 0 	showerror 	showError Z m   7 8��
�� boovtrue X k   < P [ [  \ ] \ I  < G�� ^ _
�� .sysodlogaskr        TEXT ^ m   < = ` ` � a a 2 f f p l a y / f f p r o b e   n o t   f o u n d . _ �� b c
�� 
btns b J   > A d d  e�� e m   > ? f f � g g  O K��   c �� h��
�� 
disp h m   B C��
�� stic    ��   ]  i�� i O  H P j k j m   L O l l � m m  e x i t k  f   H I��  ��  ��  ��  ��   U  n o n l     ��������  ��  ��   o  p q p l     �� r s��   r   tests for using ffprobe    s � t t 0   t e s t s   f o r   u s i n g   f f p r o b e q  u v u l     �� w x��   w � �set returnText to (do shell script ("/usr/local/bin/ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -print_format csv=p=0 " & inputLinkTest))    x � y yD s e t   r e t u r n T e x t   t o   ( d o   s h e l l   s c r i p t   ( " / u s r / l o c a l / b i n / f f p r o b e   - v   e r r o r   - s e l e c t _ s t r e a m s   a : 0   - s h o w _ e n t r i e s   s t r e a m = c o d e c _ n a m e   - p r i n t _ f o r m a t   c s v = p = 0   "   &   i n p u t L i n k T e s t ) ) v  z { z l      �� | }��   | 
 eac3    } � ~ ~  e a c 3 {   �  l     ��������  ��  ��   �  � � � l     �� � ���   � � �set returnText to (do shell script ("/usr/local/bin/ffprobe -v quiet -show_entries stream=index,codec_name,channel_layout -of csv " & actualLinkTest))    � � � �, s e t   r e t u r n T e x t   t o   ( d o   s h e l l   s c r i p t   ( " / u s r / l o c a l / b i n / f f p r o b e   - v   q u i e t   - s h o w _ e n t r i e s   s t r e a m = i n d e x , c o d e c _ n a m e , c h a n n e l _ l a y o u t   - o f   c s v   "   &   a c t u a l L i n k T e s t ) ) �  � � � l      �� � ���   � c ]program,stream,0,timed_id3stream,1,eac3,5.1(side)stream,0,timed_id3stream,1,eac3,5.1(side)    � � � � � p r o g r a m , s t r e a m , 0 , t i m e d _ i d 3  s t r e a m , 1 , e a c 3 , 5 . 1 ( s i d e )  s t r e a m , 0 , t i m e d _ i d 3  s t r e a m , 1 , e a c 3 , 5 . 1 ( s i d e ) �  � � � l     ��������  ��  ��   �  � � � i      � � � I     �� ���
�� .GURLGURLnull��� ��� TEXT � o      ���� 0 	inputlink 	inputLink��   � k     < � �  � � � r     
 � � � I     �� ����� 0 replacetext replaceText �  � � � m     � � � � �  m 3 u 8 - w r a p : �  � � � m     � � � � �  h t t p s : �  ��� � o    ���� 0 	inputlink 	inputLink��  ��   � o      ���� 0 newpath newPath �  � � � r     � � � l    ����� � I   �� ���
�� .sysoexecTEXT���     TEXT � l    ����� � b     � � � m     � � � � � � / u s r / l o c a l / b i n / f f p r o b e   - v   q u i e t   - s h o w _ e n t r i e s   s t r e a m = i n d e x , c o d e c _ n a m e , c h a n n e l _ l a y o u t   - o f   c s v   � o    ���� 0 newpath newPath��  ��  ��  ��  ��   � o      ���� 0 ffproberesult ffprobeResult �  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � ' ! test for 8 channel DTS or DTS-HD    � � � � B   t e s t   f o r   8   c h a n n e l   D T S   o r   D T S - H D �  � � � r     � � � b     � � � b     � � � m     � � � � � 2 / u s r / l o c a l / b i n / f f p l a y   - i   � o    ���� 0 newpath newPath � m     � � � � �    - a u t o e x i t � o      ���� 0 cmd   �  � � � Z    6 � ����� � E      � � � o    ���� 0 ffproberesult ffprobeResult � m     � � � � �  d t s � Z   # 2 � ����� � E   # & � � � o   # $���� 0 ffproberesult ffprobeResult � m   $ % � � � � �  7 . 1 � r   ) . � � � b   ) , � � � m   ) * � � � � � � / u s r / l o c a l / b i n / f f p l a y   - a u t o e x i t   - s t r i c t   1   - a f   ' c h a n n e l m a p = 0 | 1 | 2 | 3 | 6 | 7 | 4 | 5 : 7 . 1 '   � o   * +���� 0 newpath newPath � o      ���� 0 cmd  ��  ��  ��  ��   �  � � � l  7 7��������  ��  ��   �  ��� � I  7 <�� ���
�� .sysoexecTEXT���     TEXT � o   7 8���� 0 cmd  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� 0 replacetext replaceText �  � � � o      ���� 0 find   �  � � � o      ���� 0 replace   �  ��� � o      ���� 0 subject  ��  ��   � k     & � �  � � � r      � � � n      � � � 1    ��
�� 
txdl � 1     ��
�� 
ascr � o      ���� 0 prevtids prevTIDs �  � � � r     � � � o    ���� 0 find   � n       � � � 1    
��
�� 
txdl � 1    ��
�� 
ascr �  � � � r     � � � n     � � � 2   ��
�� 
citm � o    ���� 0 subject   � o      ���� 0 subject   �  � � � l   ��~�}�  �~  �}   �  � � � r     � � � o    �|�| 0 replace   � n       � � � 1    �{
�{ 
txdl � 1    �z
�z 
ascr �  � � � r       c     o    �y�y 0 subject   m    �x
�x 
ctxt o      �w�w 0 subject   �  r    # o    �v�v 0 prevtids prevTIDs n      	 1     "�u
�u 
txdl	 1     �t
�t 
ascr 

 l  $ $�s�r�q�s  �r  �q   �p L   $ & o   $ %�o�o 0 subject  �p   �  l     �n�m�l�n  �m  �l    i     I      �k�j�k 0 
fileexists 
FileExists �i o      �h�h 0 thefile theFile�i  �j   O      Z    �g I   �f�e
�f .coredoexnull���     **** 4    �d
�d 
file o    �c�c 0 thefile theFile�e   L     m    �b
�b boovtrue�g   L     m    �a
�a boovfals m     �                                                                                  sevs  alis    P  Mojave                         BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M o j a v e  -System/Library/CoreServices/System Events.app   / ��    !  l     �`�_�^�`  �_  �^  ! "#" l     �]�\�[�]  �\  �[  # $%$ l     �Z&'�Z  &   open TEXTWRANGLER   ' �(( $   o p e n   T E X T W R A N G L E R% )*) l     �Y+,�Y  +   paste   , �--    p a s t e* ./. l      �X01�X  0��
<key>CFBundleURLTypes</key>
	<array>
    	<dict>
        	<key>CFBundleTypeRole</key>
        	<string>Viewer</string>
        	<key>CFBundleURLIconFile</key>
        	<string></string>
        	<key>CFBundleURLName</key>
        	<string>Untitled</string>
        	<key>CFBundleURLSchemes</key>
        	<array>
            	<string>Untitled</string>
        	</array>
    	</dict>
	</array>
   1 �22 
 < k e y > C F B u n d l e U R L T y p e s < / k e y > 
 	 < a r r a y > 
         	 < d i c t > 
                 	 < k e y > C F B u n d l e T y p e R o l e < / k e y > 
                 	 < s t r i n g > V i e w e r < / s t r i n g > 
                 	 < k e y > C F B u n d l e U R L I c o n F i l e < / k e y > 
                 	 < s t r i n g > < / s t r i n g > 
                 	 < k e y > C F B u n d l e U R L N a m e < / k e y > 
                 	 < s t r i n g > U n t i t l e d < / s t r i n g > 
                 	 < k e y > C F B u n d l e U R L S c h e m e s < / k e y > 
                 	 < a r r a y > 
                         	 < s t r i n g > U n t i t l e d < / s t r i n g > 
                 	 < / a r r a y > 
         	 < / d i c t > 
 	 < / a r r a y > 
/ 343 l     �W�V�U�W  �V  �U  4 565 l     �T78�T  7   open TERMINAL   8 �99    o p e n   T E R M I N A L6 :;: l     �S<=�S  <   xattr -cr path_to.app    = �>> .   x a t t r   - c r   p a t h _ t o . a p p  ; ?@? l     �RAB�R  A e _ codesign --force --verify --verbose --sign "Developer ID Application: m erickson" path_to.app    B �CC �   c o d e s i g n   - - f o r c e   - - v e r i f y   - - v e r b o s e   - - s i g n   " D e v e l o p e r   I D   A p p l i c a t i o n :   m   e r i c k s o n "   p a t h _ t o . a p p  @ D�QD l     �P�O�N�P  �O  �N  �Q       �MEFGHI�L�K  #�J�I�H�G�F�E�D�C�M  E �B�A�@�?�>�=�<�;�:�9�8�7�6�5�4�3
�B .GURLGURLnull��� ��� TEXT�A 0 replacetext replaceText�@ 0 
fileexists 
FileExists
�? .aevtoappnull  �   � ****�> 0 foundffprobe foundFFprobe�= 0 foundffplay foundFFplay�<  0 actuallinktest actualLinkTest�;  0 safarilinktest safariLinkTest�: 0 	showerror 	showError�9  �8  �7  �6  �5  �4  �3  F �2 ��1�0JK�/
�2 .GURLGURLnull��� ��� TEXT�1 0 	inputlink 	inputLink�0  J �.�-�,�+�. 0 	inputlink 	inputLink�- 0 newpath newPath�, 0 ffproberesult ffprobeResult�+ 0 cmd  K 
 � ��* ��) � � � � ��* 0 replacetext replaceText
�) .sysoexecTEXT���     TEXT�/ =*��m+ E�O�%j E�O�%�%E�O�� �� 
�%E�Y hY hO�j G �( ��'�&LM�%�( 0 replacetext replaceText�' �$N�$ N  �#�"�!�# 0 find  �" 0 replace  �! 0 subject  �&  L � ����  0 find  � 0 replace  � 0 subject  � 0 prevtids prevTIDsM ����
� 
ascr
� 
txdl
� 
citm
� 
ctxt�% '��,E�O���,FO��-E�O���,FO��&E�O���,FO�H ���OP�� 0 
fileexists 
FileExists� �Q� Q  �� 0 thefile theFile�  O �� 0 thefile theFileP ��
� 
file
� .coredoexnull���     ****� � *�/j  eY fUI �R��ST�
� .aevtoappnull  �   � ****R k     TUU  VV  WW  XX  YY  6ZZ  ;[[  T��  �  �  S  T  �
�	 � � #�� `� f����  l�
 0 
fileexists 
FileExists�	 0 foundffprobe foundFFprobe� 0 foundffplay foundFFplay�  0 actuallinktest actualLinkTest�  0 safarilinktest safariLinkTest� 0 	showerror 	showError
� 
btns
� 
disp
� stic    � 
�  .sysodlogaskr        TEXT� U*�k+ E�O*�k+ E�O�E�O�E�OeE�O�e  �e  fE�Y hY hO�e  ���kv��� O) a UY h
�L boovtrue
�K boovtrue
�J boovfals�I  �H  �G  �F  �E  �D  �C  ascr  ��ޭ