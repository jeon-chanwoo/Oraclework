/*
    * 서브쿼리
       : 하나의 sql문안에 포함된 또다른 select문
       - 메인 sql문을 위해 보조 역할을 하는 쿼리문
*/

-- 김정보와 같은 부서의 사원 조회
-- 1. 김정보 부서 먼저 조회
SELECT DEPT_CODE
 FROM EMPLOYEE
WHERE EMP_NAME = '김정보';

-- 2. 부서가 D9인 사원 조회
SELECT EMP_NAME
 FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'; 

-- 위의 단계를 하나의 쿼리문으로 합침
SELECT EMP_NAME
 FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                    FROM EMPLOYEE
                                  WHERE EMP_NAME = '김정보'); 

-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급코드 ,급여 조회
-- 1. 전 직원의 평균급여
SELECT CEIL(AVG(SALARY))
 FROM EMPLOYEE;
 
-- 2. 평균급여보다 많이 받는 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE SALARY > (SELECT CEIL(AVG(SALARY))
                             FROM EMPLOYEE); 

 -------------------------------------------------------------------------------------------------------------------
 /*
    * 서브쿼리의 구분
       서브쿼리를 수행한 결과값이 몇 행 몇 열이냐 따라 구분
       
       - 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때(1행1열)
       - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 일 때(여러행 1열)
       - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러열 일 때(1행 여러열)
       - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 여러열 일 때(여러행 여러열)
       
       >> 서브쿼리의 종류가 뭐냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
 */

 -------------------------------------------------------------------------------------------------------------------
/*
    1. 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때(1행1열)
        일반 비교연산자 사용 가능
        =, !=, >, < .....
*/
--  1) 전 직원의 평균급여보다 더 적게 받는 직원의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                             FROM EMPLOYEE);

-- 2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
 FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                             FROM EMPLOYEE);

-- 3) 박정보 사원의 급여보다 더 많이받는 사원들의 사번, 사원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
 FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                             FROM EMPLOYEE
                             WHERE EMP_NAME = '박정보');

-- JOIN
-- 4) 박정보 사원의 급여보다 더 많이받는 사원들의 사번, 사원명, 부서명, 급여 조회
--    >> 오라클전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
 FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID    
    AND SALARY > (SELECT SALARY
                             FROM EMPLOYEE
                             WHERE EMP_NAME = '박정보');  -- 순서 상관 없음

--    >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
 FROM EMPLOYEE
   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                             FROM EMPLOYEE
                             WHERE EMP_NAME = '박정보');
                             
-- 5) 왕정보 사원과 부서코드가 같은 사원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회(단, 왕정보는 제외)
--    >> 오라클전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
 FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
   AND DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '왕정보')
   AND EMP_NAME != '왕정보';

--    >> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
 FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '왕정보')
   AND EMP_NAME != '왕정보';
   
   
-- GROUP BY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--      6.1 부서별 급여합 중 가장 큰 값 하나만 조회
SELECT MAX(SUM(SALARY))
 FROM EMPLOYEE
GROUP BY DEPT_CODE;

--     6.2 부서별 급여합이 17700000인 부서를 조회
SELECT DEPT_CODE, SUM(SALARY)
 FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 위의 쿼리문을 하나로
SELECT DEPT_CODE, SUM(SALARY)
 FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                                       FROM EMPLOYEE
                                      GROUP BY DEPT_CODE);

 -------------------------------------------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리
       : 서브쿼리의 조회 결과값이 여러행 일 때(여러행 1열)
       - IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
          > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
                                    (여러개의 결과값 중에서 가장 작은값 보다 클 경우)
          < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작은 경우
                                     (여러개의 결과값 중에서 가장 큰값 보다 작을 경우)  
                                     
        비교대상 > ANY (값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/
-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
--    1.1 조정연 또는 전지연의 직급
SELECT JOB_CODE
 FROM EMPLOYEE
WHERE EMP_NAME IN ('조정연', '전지연');

--    1.2 J3, J7 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7'); 

-- 위의 쿼리문을 한줄로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE JOB_CODE IN  (SELECT JOB_CODE
                                   FROM EMPLOYEE
                                 WHERE EMP_NAME IN ('조정연', '전지연'));

--  사원 -> 대리 -> 과장
-- 2) 대리 직급임에도 불구하고 과장직급 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여 조회
--     2.1. 과장들의 급여
SELECT SALARY
 FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장';     -- 2200, 2500, 3760

--     2.2. 직급이 대리이면서 급여가 위의 목록의 값 보다 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
    AND SALARY > ANY(2200000, 2500000, 3760000);

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
    AND SALARY > ANY (SELECT SALARY
                                    FROM EMPLOYEE
                                      JOIN JOB USING (JOB_CODE)
                                    WHERE JOB_NAME = '과장');

-- 단일행 쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
    AND SALARY > (SELECT MIN(SALARY)
                              FROM EMPLOYEE
                                JOIN JOB USING (JOB_CODE)
                            WHERE JOB_NAME = '과장');

 -------------------------------------------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리
       : 결과값이 한행이고 컬럼수가 여러개 일 때
*/
-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
--     1.1  장정보 사원의 부서코드, 직급코드
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '장정보';

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
 FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '장정보')
   AND JOB_CODE = (SELECT JOB_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '장정보');

-- 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
 FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                                     FROM EMPLOYEE
                                                    WHERE EMP_NAME = '장정보');
                                                    
-- 지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회                                                   
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID
 FROM EMPLOYEE
WHERE(DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
                                                         FROM EMPLOYEE
                                                        WHERE EMP_NAME='지정보');

 -------------------------------------------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
       : 결과값이 여러행이고 컬럼수가 여러개 일 때
*/

-- 1) 각 직급별 최소급여 금액을 받는 사원의 사번, 사원명, 직급코드, 급여 조회
--    1.1 각 직급별 최소금여
SELECT JOB_CODE, MIN(SALARY)
 FROM EMPLOYEE
GROUP BY JOB_CODE; 

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
GROUP BY JOB_CODE = 'J1' AND SALARY = 8000000 
          OR JOB_CODE = 'J2' AND SALARY = 3700000
          ....;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J1', 8000000)
      OR (JOB_CODE, SALARY) = ('J2', 3700000)
       ....;

-- 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                                FROM EMPLOYEE
                                                GROUP BY JOB_CODE);
                                                
-- 2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
 FROM EMPLOYEE
WHERE(DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY) 
                                                FROM EMPLOYEE
                                                GROUP BY DEPT_CODE);
                                                
--=================================================================
-- 인라인 뷰

/*
    인라인 뷰(INLINE VIEW)
    : 서브쿼리를 수행한 결과를 마치 테이블처럼 사용
      FROM절에 서브쿼리  작성
      
    - 주로 사용하는 예 : TOP-N분석(상위 몇위만 가져오기)
*/
-- 1) 사원들의 사번, 이름, 보너스를포함한연봉, 부서코드 조회(연봉에 NULL이 안나오게)
--      단, 보너스포함 연봉이 3000만원이상인 사원들만 조회
                                                
SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
FROM EMPLOYEE
-- WHERE 연봉 >= 30000000    오류 순서 FROM -> WHERE
WHERE (SALARY * NVL(1+BONUS,1))*12 >= 30000000;
                                                
-- 별칭을 사용하려면 INLINE VIEW 사용
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
            FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

SELECT EMP_ID, EMP_NAME, 연봉
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
            FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

/*
SELECT EMP_ID, EMP_NAME, 연봉, HIRE_DATE
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
            FROM EMPLOYEE)
WHERE 연봉 >= 30000000;  --  FROM절 뒤의 테이블에 HIRE_DATE라는 컬럼은 없다
*/

-- TOP-N분석
-- 전 직원중 급여가 가장 높은 상위 5명만 조회
-- * ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;  -- FROM -> SELECT -> ORDER

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 10
ORDER BY SALARY DESC;


-- ORDER BY를 한후, ROWNUM을 붙여줘야 한다
SELECT *
 FROM (SELECT EMP_ID, EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC);

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
 FROM (SELECT EMP_ID, EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

SELECT ROWNUM, *
 FROM (SELECT EMP_ID, EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;  -- 오류

-- 테이블에 별칭을 부여하면 가능
SELECT ROWNUM, E.*
 FROM (SELECT EMP_ID, EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

-- 2) 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
--     2.1 입사일 기준 내림차순 정렬한 INLINE VIEW
SELECT EMP_NAME, SALARY, HIRE_DATE
 FROM (SELECT *
            FROM EMPLOYEE
            ORDER BY HIRE_DATE DESC);

--    2.2          
SELECT ROWNUM, EMP_NAME, SALARY, HIRE_DATE
 FROM (SELECT *
            FROM EMPLOYEE
            ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;            
            
            
-- 3) 각 부서별 평균급여가 높은 3개 부서의 부서코드, 평균급여 조회
SELECT *
 FROM (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
            FROM EMPLOYEE
            GROUP BY DEPT_CODE
            ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3;

 -------------------------------------------------------------------------------------------------------------------
/*
    * WITH
      : 서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
      
      - 장점
        같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있고, 실행속도가 빠르다
*/
WITH TOPN_SAL AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE
                                ORDER BY 평균급여 DESC)
                            
SELECT *
 FROM TOPN_SAL
WHERE ROWNUM <= 3; 

-- 실행시 세미콜론이 붙으면(끝) 그 테이블 사용할 수 없음
-- UNION, MINUS 나 이런식으로 FROM절에 2번 쓸 때 가능
SELECT *
 FROM TOPN_SAL
WHERE ROWNUM <= 5; 

--=================================================================
/*
    * 순위 매기는 함수(WINDOW FUNCTION)
      RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
      - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                                            ex) 공동1위가 2명이면 그 다음 순위는 3위
      - DENSE_RANK() OVER(정렬기준)  :  동일한 순위 이후 그 다음 등수를 무조건 1씩 증가시킴
                                            ex) 공동1위가 2명이면 그 다음 순위는 2위      
      
*/
-- 급여가 높은 순서대로 순위 매겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
 FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
 FROM EMPLOYEE;
 
-- 급여가 상위 5위인 사람의 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
 FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;  -- 오류
-- 윈도우 함수는 WHERE절에서는 사용 못함. SELECT절에서만 사용가능

-->> 인라인 뷰를 사용하면 됨
SELECT *
 FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
            FROM EMPLOYEE)
WHERE 순위 <= 5;

-->> WITH와 같이 사용
WITH TOPN_SALARY AS(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
                                    FROM EMPLOYEE)
                                    
SELECT *
 FROM TOPN_SALARY
WHERE 순위 <= 5;

--------------------------------------------------------- 연습문제 --------------------------------------------------------
-- 1. 2020년 12월 25일의 요일 조회
SELECT TO_CHAR(to_date(20201225), 'DAY') FROM DUAL;
-- 2. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회    
select emp_name, emp_no,dept_title,job_name
from employee,job,department
where employee.job_code=job.job_code
and employee.dept_code=department.dept_id
and emp_name like '전%'
and to_number('19'||substr(emp_no,1,2)) between 1970 and 1979
and substr(emp_no,8,1)='2' ;

-- 3. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
select employee.job_code,emp_name,trunc(MONTHS_BETWEEN(sysdate ,to_date('19'||substr(emp_no,1,6)))/12) as 나이, dept_title, job_name
from employee,job,department
where employee.job_code=job.job_code
and employee.dept_code=department.dept_id
and  (to_number('19'||substr(emp_no,1,6)))= (select max(to_number('19'||substr(emp_no,1,6)))
                                        from employee);
                                        
-- 4. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select emp_id, emp_name,job_name
from employee,job
where emp_name like '%하%'
and employee.job_code = job.job_code;
-- 5. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select employee.emp_name,job_name,dept_code,dept_title
from employee, job, department
where dept_code in ('D5','D6')
and employee.job_code=job.job_code
and employee.dept_code=department.dept_id;
-- 6. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select emp_name,bonus,dept_title,national_name
from employee,department,national,location
where bonus is not null
and employee.dept_code=department.dept_id
and department.location_id=location.local_code
and location.national_code = national.national_code;
-- 7. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
select emp_name, job_name,dept_title,national_name
from employee, job, department,national,location
where employee.dept_code = department.dept_id
and employee.job_code =job.job_code
and department.location_id=location.local_code
and location.national_code = national.national_code;
-- 8. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회
select emp_name, dept_title, local_name,national_name
from employee, department, national, location
where national.national_name in('한국','일본')
and employee.dept_code = department.dept_id
and department.location_id=location.local_code
and location.national_code = national.national_code;
-- 9. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
select emp_name, dept_code
from employee
where dept_code=
                            (select dept_code
                            from employee
                            where emp_name = '하정연');
-- 10. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
select emp_name, job_name, salary
from employee,job
where bonus is null
and employee.job_code in ('J4','J7')
and employee.job_code = job.job_code;
-- 11. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT 
    SUM(CASE WHEN ent_yn = 'Y' THEN 1 ELSE 0 END) AS count_Y,
    SUM(CASE WHEN ent_yn = 'N' THEN 1 ELSE 0 END) AS count_N
FROM employee;
-- 12. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회

SELECT rownum, e.*
FROM (SELECT EMP_NAME, (SALARY * NVL(1 + BONUS, 1)) * 12 AS 연봉
                FROM EMPLOYEE
                ORDER BY 연봉 DESC) e
WHERE rownum <= 5;
-- 13. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	13-1. JOIN과 HAVING 사용   
SELECT d.dept_title, SUM(e.salary) AS dept_salary
FROM employee e
JOIN department d ON e.dept_code = d.dept_id
GROUP BY d.dept_title
HAVING SUM(e.salary) > (
    SELECT SUM(salary) * 0.2
    FROM employee
);
             
--	13-2. 인라인 뷰 사용      
SELECT dept_title, dept_salary
FROM (
    SELECT d.dept_title, SUM(e.salary) AS dept_salary
    FROM employee e
    JOIN department d ON e.dept_code = d.dept_id
    GROUP BY d.dept_title
) dept_salaries
WHERE dept_salary > (
    SELECT SUM(salary) * 0.2
    FROM employee
);
--	13-3. WITH 사용
-- 14. 부서명별 급여 합계 조회(NULL도 조회되도록)
SELECT dept_title,sum(nvl(salary,1))
from employee, department
where employee.dept_code=department.dept_id
group by dept_title;

-- 15. WITH를 이용하여 급여합과 급여평균 조회