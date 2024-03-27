# tui-editor

## 사용 방법
- npm을 통한 설치는 Node.js 환경에서만 가능하기 때문에 순수 javaScript로 CDN을 통해 소스 코드를 불러오는 방법을 사용했습니다.

~~~

const editor = new toastui.Editor({
  el: document.querySelector('#editor'),
  height: '500px',
  initialEditType: 'wysiwyg',
  initialValue: existingContent || '',
  previewStyle: 'vertical',
  placeholder: '',

~~~
- toastui의 Editor 객체를 만들고 기본 설정을 합니다
  - el: Editor가 적용될 element를 작성합니다. 위의 경우 id가 editor인 div에 editor가 적용됩니다.
  - height: editor의 높이를 설정합니다
  - initialEditType: editor가 처음 로딩될 화면을 고정합니다. markdown, wysiwyg 중 하나를 선택합니다.
  - initialValue: 초기 값을 설정합니다. 마크다운에 입력이 됩니다.
  - previewStyle: 마크다운 미리보기 스타일을 설정합니다. tab | vertical
  - placeholder: 입력 필드에 짧은 도움말을 설정합니다.
<br>

~~~

  hooks: {
    async addImageBlobHook(blob, callback) { // 이미지 업로드 로직 커스텀
      try {
        const fileExtension = blob.name.split('.').pop().toLowerCase();
        if (fileExtension === 'svg') {
          alert('svg 형식은 지원하지 않습니다');
          return;
        }

        const formData = new FormData();
        formData.append('image', blob);
        
        const response = await fetch('/image-upload', {
          method: 'POST',
          body: formData,
        });
        if (response.status !== 201) {
          alert('업로드 실패');
          return;
        }

        const {fileId, fileName} = await response.json();
        fileIdList.push(fileId);

        const resource = `/image-load/${fileName}`;
        callback(resource, 'image alt attribute');
      } catch (error) {
        alert('업로드 실패 : ', error);
      }
    }
  }

~~~

- hook option의 addImageBlobHook을 통해 업로드한 파일 정보를 Blob 또는 File 타입의 객체로 전달받을 수 있습니다.
  1. 위는 Blob 타입의 객체로 설정을 했습니다. 파일을 업로드하면 blob으로 파일 객체가 넘어옵니다. 파일 객체는 name, size, type으로 구성되어 있습니다.
  2. 에디터에 업로드한 이미지를 FormData 객체에 저장합니다. 컨트롤러 uploadEditorImage 메서드의 파라미터인 'image'와 formData에 append 하는 key('image')값은 동일해야 합니다.
  3. fetch를 사용해 /image-upload로 POST 요청을 보냅니다. formData에 저장한 이미지가 처리됩니다.
  4. 보낸 요청의 응답을 받습니다. DB의 Relation table에 저장하기 위해 fileId, 저장된 이미지를 불러오기 위해 fileName을 응답으로 설정했습니다.
  5. addImageBlobHook의 callback 함수를 통해 디스크에 저장된 이미지를 에디터에 렌더링합니다.
  6. error 발생 시 사용자에게 알리기 위해 alert를 설정합니다.
 <br>


## REFERENCE
https://ui.toast.com/tui-editor <br>
https://congsong.tistory.com/68  
