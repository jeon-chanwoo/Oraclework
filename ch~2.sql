SELECT 
    department_name AS 학과명, category AS 계열
FROM tb_department
UNION ALL
SELECT '총 행 수' AS 학과명, TO_CHAR(COUNT(*)) AS 계열
FROM tb_department;

select department_name||'의 정원은'||capacity||'명 입니다.'
from tb_department;

SELECT student_name
FROM tb_student
WHERE student_no IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY student_name DESC; 

select department_name,category
from tb_department
where capacity between 20 and 30; 

select professor_name
from tb_professor
where department_no is null;

select student_name
from tb_student
where department_no is null;

select class_no
from tb_class
where preattending_class_no is not null;

select distinct category
from tb_department;

select student_no, student_name,student_ssn
    from tb_student
    where absence_yn ='N' 
        AND extract(year from entrance_date)=2002
        AND SUBSTR(student_address,1,2)= '전주'
            order by student_name;
        
select student_no 학번, student_name 이름,to_char(entrance_date,'yyyy-mm-dd') 입학년도
    from tb_student
    where department_no='002'
    order by entrance_date asc;
    
select professor_name, professor_ssn
    from tb_professor
    where professor_name not like '___';
    
select professor_name 교수이름, trunc(months_between(sysdate,to_date(lpad(professor_ssn,6)))/12) as 나이
    from tb_professor
    where substr(professor_ssn,8,1) = '1'
    and trunc(months_between(sysdate,to_date(lpad(professor_ssn,6)))/12)>'0'
    order by 2 asc;
    
select substr(professor_name,2,2) 이름
    from tb_professor;
    
select student_no,student_name
from tb_student
    where  ceil(months_between(entrance_date,to_date(lpad(student_ssn,6)))/12)>19;
    
SELECT TO_CHAR(to_date(20201225), 'DAY') FROM DUAL;

select to_date('99/10/11','YY/MM/DD'),to_date('49/10/11','YY/MM/DD'),
    to_date('99/10/11','RR/MM/DD'),to_date('49/10/11','RR/MM/DD')
from dual;

select student_no, student_name
    from tb_student
    where student_no not like 'A%';
    
select round(avg(point),1)
    from tb_grade
    where student_no = 'A517178';
    
SELECT department_no, COUNT(*) AS class_count
FROM tb_class
GROUP BY department_no
ORDER BY department_no ASC;

select count(*)
    from tb_student
    where coach_professor_no is null;
    
select  substr(term_no,1,4),round(avg(point),1)
from tb_grade,tb_student
    where tb_grade.student_no like 'A112113'
    group by substr(term_no,1,4)
    order by substr(term_no,1,4);

SELECT 
    tb_class.department_no AS "학과코드명", 
    COUNT(*) AS "휴학생 수"
FROM tb_student
JOIN tb_class ON tb_student.department_no = tb_class.department_no
WHERE  tb_student.absence_yn = 'Y'
GROUP BY  tb_class.department_no
ORDER BY  tb_class.department_no ASC;

select student_name, count(*)
    from tb_student
    group by tb_student.student_name
    having count(*)>1;
    
select  substr(term_no,1,4),substr(term_no,5,2),round(avg(point),1)
from tb_grade,tb_student
    where tb_grade.student_no like 'A112113'
    group by cube (substr(term_no,1,4),substr(term_no,5,2))
    order by substr(term_no,1,4);