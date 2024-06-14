--한줄주석 (ctrl+/)
/*
여러줄 주석 alt+shift+c
*/
--커서 있는 줄 실행 ctrl+enter
--나의 계정 보기
show user;

select *
from dba_users;
select username,user_id
from dba_users;
--내가 사용할 user계정 생성
--일반사용자는 c##으로 시작하는 이름을 가져야 함
--일반 사용자 비밀번호는 문자만 가능하다.
CREATE USER c##user4 
IDENTIFIED by "1234";
drop user c##user4
CASCADE;

alter session set "_oracle_script"=true;

--수업시간에 사용할 user 생성
create user tjoeun
identified by 1234;


grant resource, connect to tjoeun;

--insert시 생성된 유저에게 테이블스페이스에 얼마만큼의 영역을 할당할 것인지 정해줘야함
alter user tjoeun default tablespace users quota unlimited on users;

create user chjoeun
identified by 1234;

grant resource, connect to chjoeun;

alter user chjoeun default tablespace users quota unlimited on users;